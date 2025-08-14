class GetVideoIdSpecialReq {
  final String part;
  final String playlistId;
  final int maxResults;

  GetVideoIdSpecialReq({
    required this.part,
    required this.playlistId,
    required this.maxResults,
  });

  Map<String, dynamic> toMap() {
    return {
      'part': part,
      'playlistId': playlistId,
      'maxResults': maxResults
    };
  }
}
