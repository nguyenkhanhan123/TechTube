class SendCmtRes {
  final String commentId;

  SendCmtRes({required this.commentId});

  factory SendCmtRes.fromJson(Map<String, dynamic> json) {
    return SendCmtRes(
      commentId: json['id'] as String,
    );
  }
}
