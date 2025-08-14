class SearchVideoReq {
  final String part;
  final String q;
  final String type;
  final int maxResults;
  final String regionCode;
  final String videoCategoryId;
  final String key;

  SearchVideoReq({
    required this.part,
    required this.q,
    required this.type,
    required this.maxResults,
    required this.regionCode,
    required this.videoCategoryId,
    required this.key,
  });

  Map<String, dynamic> toMap() {
    return {
      'part': part,
      'q': q,
      'type': type,
      'maxResults': maxResults,
      'regionCode': regionCode,
      'videoCategoryId': videoCategoryId,
      'key': key,
    };
  }
}
