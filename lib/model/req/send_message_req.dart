class SendMessageReq {
  final String model;
  final List<Messages> messages;

  SendMessageReq({required this.model, required this.messages});

  Map<String, dynamic> toMap() => {
    'model': model,
    'messages': messages.map((m) => m.toMap()).toList(),
  };
}

class Messages {
  final String role;
  final String content;

  Messages({required this.role, required this.content});

  Map<String, dynamic> toMap() => {
    'role': role,
    'content': content,
  };
}


