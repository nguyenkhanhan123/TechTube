class GetVideoReq {
  final String part;
  final String chart;
  final int maxResults;
  final String regionCode;
  final String videoCategoryId;
  final String key;
  final String? pageToken;

  GetVideoReq({
    required this.part,
    required this.chart,
    required this.maxResults,
    required this.regionCode,
    required this.videoCategoryId,
    required this.key,
    this.pageToken,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'part': part,
      'chart': chart,
      'maxResults': maxResults,
      'regionCode': regionCode,
      'videoCategoryId': videoCategoryId,
      'key': key,
    };

    if (pageToken != null) {
      map['pageToken'] = pageToken!;
    }

    return map;
  }

  GetVideoReq copyWith({String? pageToken}) {
    return GetVideoReq(
      part: part,
      chart: chart,
      maxResults: maxResults,
      regionCode: regionCode,
      videoCategoryId: videoCategoryId,
      key: key,
      pageToken: pageToken ?? this.pageToken,
    );
  }
}
