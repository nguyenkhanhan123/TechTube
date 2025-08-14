class GetMyChannelReq {
  final String part;
  final bool? mine;

  GetMyChannelReq({
    required this.part,
    this.mine,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'part': part,
    };
    if (mine != null) map['mine'] = mine.toString();
    return map;
  }
}
