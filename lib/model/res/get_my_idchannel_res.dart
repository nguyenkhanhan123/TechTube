class GetMyIdchannelRes {
  final String id;

  GetMyIdchannelRes({
    required this.id,
  });

  factory GetMyIdchannelRes.fromJson(Map<String, dynamic> json) {
    final item = (json['items'] as List).isNotEmpty ? json['items'][0] : {};
    return GetMyIdchannelRes(
      id: item['id'] ?? ''
    );
  }
}
