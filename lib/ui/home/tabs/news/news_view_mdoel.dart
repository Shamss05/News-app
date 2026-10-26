import 'package:assignment_7/api/api_manger.dart';
import 'package:assignment_7/core/base/base_view_model.dart';
import 'package:assignment_7/models/articles_response.dart' hide Source;
import 'package:assignment_7/models/news_category.dart';
import 'package:assignment_7/models/sources_response.dart';

class NewsViewModel extends BaseViewModel {
  final NewsCategory category;
  final ApiManger apiManger;
  NewsViewModel(this.category, {ApiManger? apiManger})
    : apiManger = apiManger ?? ApiManger();

  List<Source> sources = [];
  String? sourcesError;
  bool sourcesLoading = false;
  List<Article> articles = [];
  String? articlesError;
  bool articlesLoading = false;
  int selectedIndex = 0;
  bool _disposed = false;
  int _articleRequest = 0;

  @override
  void dispose() {
    _disposed = true;
    _articleRequest++;
    apiManger.dio.close(force: true);
    super.dispose();
  }

  void changeSelectedIndex(int index) {
    if (_disposed ||
        index < 0 ||
        index >= sources.length ||
        selectedIndex == index) {
      return;
    }
    selectedIndex = index;
    getArticles();
  }

  Future<void> getSources() async {
    if (_disposed || sourcesLoading) return;
    sourcesLoading = true;
    sourcesError = null;
    notifyListeners();
    try {
      final response = await apiManger.getSources(category.categoryId);
      if (_disposed) return;
      if (response.status == 'error') {
        throw Exception(response.message ?? 'Unable to load news sources.');
      }
      sources = (response.sources ?? [])
          .where((source) => source.id?.isNotEmpty == true)
          .toList();
      selectedIndex = 0;
      articles = [];
      articlesError = null;
      if (sources.isNotEmpty) await getArticles();
    } catch (e) {
      if (!_disposed) sourcesError = e.toString();
    } finally {
      if (!_disposed) {
        sourcesLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> getArticles() async {
    if (_disposed || sources.isEmpty) return;
    final request = ++_articleRequest;
    final sourceId = sources[selectedIndex].id!;
    articlesLoading = true;
    articlesError = null;
    articles = [];
    notifyListeners();
    try {
      final response = await apiManger.getArticles(sourceId);
      if (_disposed || request != _articleRequest) return;
      if (response.status == 'error') {
        throw Exception(response.message ?? 'Unable to load articles.');
      }
      articles = response.articles ?? [];
    } catch (e) {
      if (!_disposed && request == _articleRequest) {
        articlesError = e.toString();
      }
    } finally {
      if (!_disposed && request == _articleRequest) {
        articlesLoading = false;
        notifyListeners();
      }
    }
  }
}
