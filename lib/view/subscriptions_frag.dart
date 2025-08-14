import 'package:flutter/material.dart';
import 'package:my_youtube/model/req/get_subscriptions_channel_req.dart';
import '../api/youtube_api.dart';
import '../common_utils.dart';
import '../model/res/get_subscriptions_res.dart';
import 'item_subscriptions.dart';

class SubscriptionsFrag extends StatefulWidget {
  @override
  _SubscriptionsFragState createState() => _SubscriptionsFragState();
}

class _SubscriptionsFragState extends State<SubscriptionsFrag> {
  List<SubscribedChannel> channel = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadChannels();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadChannels();
  }

  Future<void> loadChannels() async {
    final api = YoutubeApi();
    final accessToken = await CommonUtils().getPref("accessToken");

    if (accessToken == null || accessToken.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final result = await api.getSubscribedChannelWithToken(
      GetSubscriptionsChannelReq(
        part: 'snippet,contentDetails',
        maxResults: 50,
        mine: true,
      ),
      accessToken,
    );

    setState(() {
      channel = result.items;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : RefreshIndicator(
        onRefresh: loadChannels,
        child: channel.isEmpty
            ? ListView(
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: 200),
            Center(
              child: Text("Bạn chưa đăng ký kênh nào hoặc chưa đăng nhập"),
            ),
          ],
        )
            : ListView.builder(
          itemCount: channel.length,
          itemBuilder: (context, index) {
            final i = channel[index];
            return SubscribedChannelItem(channel: i);
          },
        ),
      ),
    );
  }
}
