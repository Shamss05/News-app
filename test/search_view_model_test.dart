import 'dart:async';
import 'package:assignment_7/api/api_manger.dart';
import 'package:assignment_7/models/articles_response.dart';
import 'package:assignment_7/ui/search/search_view_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeSearchApi extends ApiManger {
  final requests =
      <({String query, int page, Completer<ArticlesResponse> result})>[];
  @override
  Future<ArticlesResponse> searchArticles(
    String query, {
    int page = 1,
    int pageSize = 20,
    CancelToken? cancelToken,
  }) {
    final result = Completer<ArticlesResponse>();
    requests.add((query: query, page: page, result: result));
    return result.future;
  }
}

ArticlesResponse pageOf(int start, int count, int total) => ArticlesResponse(
  status: 'ok',
  totalResults: total,
  articles: List.generate(
    count,
    (i) => Article(
      title: 'Article ${start + i}',
      url: 'https://example.com/${start + i}',
    ),
  ),
);

void main() {
  test(
    'Appends pages, blocks duplicate loads and stops at totalResults',
    () async {
      final api = FakeSearchApi();
      final model = SearchViewModel(api: api);
      addTearDown(model.dispose);
      model.changeQuery('science', immediate: true);
      await model.loadMore();
      expect(api.requests.length, 1);
      api.requests[0].result.complete(pageOf(0, 20, 25));
      await Future<void>.delayed(Duration.zero);
      expect(model.articles.length, 20);
      expect(model.hasMore, isTrue);
      final next = model.loadMore();
      expect(api.requests.last.page, 2);
      api.requests.last.result.complete(pageOf(20, 5, 25));
      await next;
      expect(model.articles.length, 25);
      expect(model.hasMore, isFalse);
      await model.loadMore();
      expect(api.requests.length, 2);
    },
  );

  test(
    'Ignores old search responses and clear cancels pending results',
    () async {
      final api = FakeSearchApi();
      final model = SearchViewModel(api: api);
      addTearDown(model.dispose);
      model.changeQuery('old', immediate: true);
      model.changeQuery('new', immediate: true);
      api.requests[1].result.complete(pageOf(100, 1, 1));
      await Future<void>.delayed(Duration.zero);
      api.requests[0].result.complete(pageOf(0, 1, 1));
      await Future<void>.delayed(Duration.zero);
      expect(model.articles.single.title, 'Article 100');
      model.changeQuery('third', immediate: true);
      model.changeQuery('');
      api.requests[2].result.complete(pageOf(200, 1, 1));
      await Future<void>.delayed(Duration.zero);
      expect(model.articles, isEmpty);
      expect(model.hasMore, isFalse);
    },
  );

  test('Failed next page keeps results and retries the same page', () async {
    final api = FakeSearchApi();
    final model = SearchViewModel(api: api);
    addTearDown(model.dispose);
    model.changeQuery('science', immediate: true);
    api.requests[0].result.complete(pageOf(0, 20, 30));
    await Future<void>.delayed(Duration.zero);
    final failed = model.loadMore();
    api.requests[1].result.completeError(Exception('Network error'));
    await failed;
    expect(model.error, isNotNull);
    expect(model.articles.length, 20);
    final retry = model.loadMore();
    expect(api.requests.last.page, 2);
    api.requests.last.result.complete(pageOf(20, 10, 30));
    await retry;
    expect(model.error, isNull);
    expect(model.articles.length, 30);
  });
}
