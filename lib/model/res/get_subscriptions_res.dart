class GetSubscriptionsRes {
  final List<SubscribedChannel> items;

  GetSubscriptionsRes({required this.items});

  factory GetSubscriptionsRes.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>;
    final items = itemsJson.map((item) => SubscribedChannel.fromJson(item)).toList();
    return GetSubscriptionsRes(items: items);
  }
}

class SubscribedChannel {
  final String title;
  final String channelId;
  final String thumbnailUrl;
  final int totalItemCount;

  SubscribedChannel({
    required this.title,
    required this.channelId,
    required this.thumbnailUrl,
    required this.totalItemCount,
  });

  factory SubscribedChannel.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'];
    final contentDetails = json['contentDetails'];
    return SubscribedChannel(
      title: snippet['title'],
      channelId: snippet['resourceId']['channelId'],
      thumbnailUrl: snippet['thumbnails']['medium']['url'],
      totalItemCount: contentDetails['totalItemCount']
    );
  }
}
