class GetPlaylistsChannelReq {
  final String part;
  final String channelId;
  final String key;

  GetPlaylistsChannelReq({
    required this.part,
    required this.channelId,
    required this.key,
  });

  Map<String, dynamic> toMap() {
    return {
      'part': part,
      'channelId': channelId,
      'key': key
    };
  }
}
