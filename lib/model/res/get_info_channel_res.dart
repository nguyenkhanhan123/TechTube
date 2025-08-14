class GetInfoChannelRes {
  final List<ChannelInfoItem> items;

  GetInfoChannelRes({required this.items});

  factory GetInfoChannelRes.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>;
    final items =
        itemsJson.map((item) => ChannelInfoItem.fromJson(item)).toList();
    return GetInfoChannelRes(items: items);
  }
}

class ChannelInfoItem {
  final String channelId;
  final String title;
  final String thumbnailUrl;
  final String subscriberCount;

  ChannelInfoItem({
    required this.channelId,
    required this.title,
    required this.thumbnailUrl,
    required this.subscriberCount,
  });

  factory ChannelInfoItem.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'];
    final statistics = json['statistics'] ?? {};

    return ChannelInfoItem(
      channelId: json['id'] ?? '',
      title: snippet['title'] ?? '',
      thumbnailUrl: snippet['thumbnails']['default']['url'] ?? '',
      subscriberCount: statistics['subscriberCount'] ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': channelId,
      'snippet': {
        'title': title,
        'thumbnails': {
          'default': {'url': thumbnailUrl},
        },
      },
      'statistics': {'subscriberCount': subscriberCount},
    };
  }
}
