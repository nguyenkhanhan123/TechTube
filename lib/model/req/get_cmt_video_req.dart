class GetCmtVideoReq {
  final String part;
  final String videoId;
  final int maxResults;
  final String key;

  GetCmtVideoReq({
    required this.part,
    required this.videoId,
    required this.maxResults,
    required this.key,
  });

  Map<String, dynamic> toMap() {
    return {
      'part': part,
      'videoId': videoId,
      'maxResults': maxResults,
      'key': key
    };
  }
}
