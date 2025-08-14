import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../common_utils.dart';
import 'main_act.dart';

class SplashAct extends StatefulWidget {
  @override
  _SplashScreenState createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashAct> {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  @override
  void initState() {
    super.initState();
    CommonUtils().clearPref('accessToken');
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 1));

    await _googleSignIn.initialize(
      clientId:
      '1004122834073-mknp9me3h6h9qtvusmvk854cmmm511ii.apps.googleusercontent.com',
      serverClientId:
      '1004122834073-ms51qnbfj15pdoj0ku1jduc86p235ois.apps.googleusercontent.com',
    );

    GoogleSignInAccount? account =
    await _googleSignIn.attemptLightweightAuthentication();

    if (account != null) {
      final authClient = _googleSignIn.authorizationClient;
      final scopes = ['email', 'https://www.googleapis.com/auth/youtube.force-ssl'];

      var authorization = await authClient.authorizationForScopes(scopes);

      authorization ??= await authClient.authorizeScopes(scopes);

      final accessToken = authorization.accessToken;
      print('🔑 Access Token: $accessToken');
      CommonUtils().savePref("accessToken", accessToken ?? '');

      print('📧 Email: ${account.email}');
      CommonUtils().savePref("email", account.email);

      print('📧 DisplayName: ${account.displayName}');
      CommonUtils().savePref("displayName", account.displayName ?? '');

      print('📧 PhotoUrl: ${account.photoUrl}');
      CommonUtils().savePref("photoUrl", account.photoUrl ?? '');
    } else {
      print('🔓 Chưa đăng nhập');
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainAct()),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/ic_logo.png'),
            SizedBox(height: 29),
            Text(
              'TechTube',
              style: TextStyle(
                fontFamily: 'Whimsy',
                fontSize: 36,
                color: Color(0xFF6D2EE1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
