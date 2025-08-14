class SendMessageRes {
  final String content;

  SendMessageRes({required this.content});

  factory SendMessageRes.fromJson(Map<String, dynamic> json) {
    final choices = json['choices'] as List<dynamic>;
    final message = choices.first['message'];
    final content = message['content'] as String;
    return SendMessageRes(content: content);
  }
}
