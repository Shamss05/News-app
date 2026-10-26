import 'dart:async';
import 'package:assignment_7/api/api_manger.dart';
import 'package:assignment_7/models/articles_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class SearchViewModel extends ChangeNotifier {
  final ApiManger _api;
  SearchViewModel({ApiManger? api}) : _api = api ?? ApiManger();

  static const pageSize = 20;
  final List<Article> articles = [];
  String query = '';
  String? error;
  bool isLoading = false;
  bool hasMore = false;
  int _page = 0;
  int _received = 0;
  int _generation = 0;
  bool _disposed = false;
  Timer? _debounce;
  CancelToken? _cancelToken;

  void changeQuery(String value, {bool immediate = false}) {
    if (_disposed) return;
    final nextQuery = value.trim();
    if (nextQuery == query) {
      if (immediate && _debounce?.isActive == true) {
        _debounce?.cancel();
        loadMore();
      }
      return;
    }
    _debounce?.cancel();
    _cancelToken?.cancel();
    _generation++;
    query = nextQuery;
    articles.clear();
    _page = 0;
    _received = 0;
    error = null;
    isLoading = false;
    hasMore = query.isNotEmpty;
    notifyListeners();
    if (query.isEmpty) return;
    if (immediate) {
      loadMore();
    } else {
      _debounce = Timer(const Duration(milliseconds: 500), loadMore);
    }
  }

  Future<void> loadMore() async {
    if (_disposed || query.isEmpty || isLoading || !hasMore) return;
    _debounce?.cancel();
    final generation = _generation;
    final nextPage = _page + 1;
    final token = CancelToken();
    _cancelToken = token;
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final response = await _api.searchArticles(
        query,
        page: nextPage,
        pageSize: pageSize,
        cancelToken: token,
      );
      if (_disposed || generation != _generation) return;
      if (response.status == 'error') {
        throw Exception(response.message ?? 'Unable to search articles.');
      }
      final results = response.articles ?? [];
      _page = nextPage;
      _received += results.length;
      final urls = articles
          .map((article) => article.url)
          .whereType<String>()
          .toSet();
      for (final article in results) {
        final url = article.url;
        if (url == null || url.isEmpty || urls.add(url)) articles.add(article);
      }
      hasMore =
          results.length == pageSize &&
          (response.totalResults == null || _received < response.totalResults!);
    } catch (e) {
      if (_disposed ||
          generation != _generation ||
          (e is DioException && CancelToken.isCancel(e))) {
        return;
      }
      error = e is DioException
          ? (e.response?.data is Map
                ? e.response?.data['message']?.toString() ?? 'Unable to load results. Please try again.' : 'Unable to load results. Check your connection and try again.') : e.toString().replaceFirst('Exception: ', '');
    } finally {
      if (!_disposed && generation == _generation) {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _generation++;
    _debounce?.cancel();
    _cancelToken?.cancel();
    _api.dio.close(force: true);
    super.dispose();
  }
}
