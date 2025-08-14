class SendCmtReq {
  final String videoId;
  final String text;

  SendCmtReq({
    required this.videoId,
    required this.text,
  });

  Map<String, dynamic> toMap() {
    return {
      "snippet": {
        "videoId": videoId,
        "topLevelComment": {
          "snippet": {
            "textOriginal": text,
          }
        }
      }
    };
  }
}
