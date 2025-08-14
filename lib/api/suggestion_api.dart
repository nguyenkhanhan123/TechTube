import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:my_youtube/model/req/get_suggestion_req.dart';

class SuggestionApi {
  final Dio _dio;

  SuggestionApi()
    : _dio = Dio(
        BaseOptions(
          baseUrl: 'https://suggestqueries.google.com/complete/',
          connectTimeout: Duration(seconds: 10),
          receiveTimeout: Duration(seconds: 10),
        ),
      );

  Future<List<String>> getSuggestion(GetSuggestionReq req) async {
    final response = await _dio.get(
      'search',
      queryParameters: req.toMap(),
      options: Options(responseType: ResponseType.bytes),
    );

    final decoded = const Latin1Decoder().convert(response.data);

    final data = jsonDecode(decoded);

    if (data is List && data.length >= 2 && data[1] is List) {
      return List<String>.from(data[1]);
    } else {
      return [];
    }
  }
}
