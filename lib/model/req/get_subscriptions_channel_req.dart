class GetSubscriptionsChannelReq {
  final String part;
  final bool? mine;
  final int maxResults;

  GetSubscriptionsChannelReq({
    required this.part,
    this.mine,
    required this.maxResults,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'part': part,
      'maxResults': maxResults.toString()
    };
    if (mine != null) map['mine'] = mine.toString();
    return map;
  }
}
