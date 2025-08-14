import 'package:flutter/material.dart';
import 'package:my_youtube/view/info_channel_activity.dart';

import '../model/res/get_subscriptions_res.dart';

class SubscribedChannelItem extends StatelessWidget {
  final SubscribedChannel channel;

  const SubscribedChannelItem({
    super.key,
    required this.channel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(5, 8, 5, 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              channel.thumbnailUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    channel.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${channel.totalItemCount} videos',
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'Nunito',
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InfoChannelActivity(id: channel.channelId)),
              );
            },
          )
          ,
        ],
      ),
    );
  }
}
