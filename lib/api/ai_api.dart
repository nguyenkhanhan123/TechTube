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
