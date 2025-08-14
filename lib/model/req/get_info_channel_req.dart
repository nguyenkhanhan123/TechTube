class GetInfoChannelReq {
  final String part;
  final String id;
  final String key;

  GetInfoChannelReq({
    required this.part,
    required this.id,
    required this.key,
  });

  Map<String, dynamic> toMap() {
    return {
      'part': part,
      'id': id,
      'key': key
    };
  }
}
