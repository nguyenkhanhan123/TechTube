import 'package:dio/dio.dart';
import 'package:my_youtube/model/req/send_message_req.dart';
import 'package:my_youtube/model/res/send_message_res.dart';

class AIApi {
  final Dio _dio;

  AIApi()
      : _dio = Dio(
    BaseOptions(
      baseUrl: 'https://openrouter.ai/api/v1/chat/',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 30),
    ),
  );

  Future<SendMessageRes> sendMessage(SendMessageReq req) async {
    final response = await _dio.post(
      'completions',
        data: req.toMap(),
      options: Options(
        headers: {
          'Authorization': 'Bearer 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',
          'Content-Type': 'application/json',
        }
      )
    );
    return SendMessageRes.fromJson(response.data);
  }
}
