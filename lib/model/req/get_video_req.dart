class GetVideoReq {
  final String part;
  final String chart;
  final int maxResults;
  final String regionCode;
  final String videoCategoryId;
  final String key;

  GetVideoReq({
    required this.part,
    required this.chart,
    required this.maxResults,
    required this.regionCode,
    required this.videoCategoryId,
    required this.key,
  });

  Map<String, dynamic> toMap() {
    return {
      'part': part,
      'chart': chart,
      'maxResults': maxResults,
      'regionCode': regionCode,
      'videoCategoryId': videoCategoryId,
      'key': key,
    };
  }
}
