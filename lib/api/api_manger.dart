import 'package:dio/dio.dart';

import '../models/articles_response.dart';
import '../models/sources_response.dart';

class ApiManger {
  final dio = Dio();
  ApiManger() {
    dio.options = BaseOptions(
      baseUrl: "https://newsapi.org",
      receiveTimeout: Duration(seconds: 180),
      connectTimeout: Duration(seconds: 180),
      headers: {"Authorization": "b990bece7c934832bd10807548ee54f7"},
    );
  }
  Future<SourcesResponse> getSources(String category) async {
    Response response = await dio.get("/v2/top-headlines/sources", queryParameters: {"category": category},);
    return SourcesResponse.fromJson(response.data);
  }

  Future<ArticlesResponse> getArticles(String source) async {
    Response response = await dio.get("/v2/top-headlines", queryParameters: {"sources": source},);
    return ArticlesResponse.fromJson(response.data);
  }

  Future<ArticlesResponse> searchArticles(
    String query, {
    int page = 1,
    int pageSize = 20,
    CancelToken? cancelToken,
  }) async {
    final response = await dio.get('/v2/everything', queryParameters: {'q': query, 'page': page, 'pageSize': pageSize, 'sortBy': 'publishedAt',}, cancelToken: cancelToken,);
    return ArticlesResponse.fromJson(response.data);
  }
}
