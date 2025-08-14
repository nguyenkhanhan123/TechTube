class GetViewVideoReq {
  final String part;
  final String id;
  final String key;

  GetViewVideoReq({
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
