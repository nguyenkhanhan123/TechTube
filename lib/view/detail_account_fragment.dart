import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:my_youtube/api/youtube_api.dart';
import 'package:my_youtube/common_utils.dart';
import 'package:my_youtube/model/req/get_my_channel_req.dart';
import 'package:my_youtube/view/video_special_id_frag.dart';
import 'package:my_youtube/view/video_watched_frag.dart';

import 'my_channel_activity.dart';

class DetailAccount extends StatefulWidget {
  final VoidCallback? onSignOut;
  const DetailAccount({Key? key, this.onSignOut}) : super(key: key);

  @override
  _DetailAccountState createState() => _DetailAccountState();
}

class _DetailAccountState extends State<DetailAccount> {
  int _currentIndex = 0;
  String? photoUrl;
  String? email;
  String? displayName;
  String? idChannel;
  List<Widget> _fragments = [
    VideoWatchedFrag(),
    Center(child: Text("Fragment Video yêu thích", style: TextStyle(fontSize: 18))),
  ];

  late TapGestureRecognizer _logoutRecognizer;
  late TapGestureRecognizer _viewChannelRecognizer;

  @override
  void initState() {
    super.initState();
    _logoutRecognizer = TapGestureRecognizer()..onTap = _handleSignOut;
    _viewChannelRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyChannelActivity()),
        );
      };

    _loadPhotoUrl();
  }

  @override
  void dispose() {
    _logoutRecognizer.dispose();
    _viewChannelRecognizer.dispose();
    super.dispose();
  }

  void _loadPhotoUrl() async {
    final url = await CommonUtils().getPref("photoUrl");
    final mail = await CommonUtils().getPref("email");
    final name = await CommonUtils().getPref("displayName");
    final accessToken = await CommonUtils().getPref("accessToken");

    try {
      final res = await YoutubeApi()
          .getMyIdChannelWithToken(GetMyChannelReq(part: 'id', mine: true), accessToken.toString());
      setState(() {
        photoUrl = url?.toString();
        email = mail?.toString();
        displayName = name?.toString();
        _fragments = [
          VideoWatchedFrag(),
          VideoSpecialIdFrag(playlistId: convertIdToLL(res.id)),
        ];
      });
    } catch (e) {
      setState(() {
        photoUrl = url?.toString();
        email = mail?.toString();
        displayName = name?.toString();
      });
      print('Lấy channel thất bại: $e');
    }
  }

  Future<void> _handleSignOut() async {
    print("Bạn vừa nhấn vào 'đăng xuất' - bắt đầu signOut...");
    final utils = CommonUtils();

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await googleSignIn.signOut();
      try {
        await googleSignIn.disconnect();
      } catch (_) {

      }
    } catch (e) {
      print('Lỗi khi signOut Google: $e');
    }
    try {
      await (utils.clearPref.call('accessToken'));
      await (utils.clearPref.call('email'));
      await (utils.clearPref.call('displayName'));
      await (utils.clearPref.call('photoUrl'));
    } catch (e) {
      await utils.savePref("accessToken", "");
      await utils.savePref("email", "");
      await utils.savePref("displayName", "");
      await utils.savePref("photoUrl", "");
    }

    widget.onSignOut?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.grey[200],
                    backgroundImage:
                    photoUrl != null ? NetworkImage(photoUrl!) : null,
                    child: photoUrl == null
                        ? Icon(Icons.person, size: 32, color: Colors.grey)
                        : null,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName ?? "Tên người dùng",
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          email ?? "Email",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Đăng xuất",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: _logoutRecognizer,
                              ),
                              TextSpan(
                                text: '  •  ',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 16,
                                ),
                              ),
                              TextSpan(
                                text: "Xem kênh >",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: _viewChannelRecognizer,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: Row(
              children: [
                _buildTabButton("Video đã xem", 0),
                _buildTabButton("Video yêu thích", 1),
              ],
            ),
          ),
          SizedBox(height: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: IndexedStack(
                index: _currentIndex,
                children: _fragments,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blueAccent : Colors.transparent,
            borderRadius: BorderRadius.horizontal(
              left: index == 0 ? Radius.circular(10) : Radius.zero,
              right: index == 1 ? Radius.circular(10) : Radius.zero,
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 16,
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String convertIdToLL(String id) {
    if (id.length < 2) return id;
    return 'LL${id.substring(2)}';
  }
}
