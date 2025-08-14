import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../common_utils.dart';
import '../db/db.dart';

class SignIn extends StatelessWidget {
  final VoidCallback onSignedIn;

  const SignIn({super.key, required this.onSignedIn});

  Future<void> _handleSignIn(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;

    try {
      await googleSignIn.initialize(
        clientId:
        '1004122834073-mknp9me3h6h9qtvusmvk854cmmm511ii.apps.googleusercontent.com',
        serverClientId:
        '1004122834073-ms51qnbfj15pdoj0ku1jduc86p235ois.apps.googleusercontent.com',
      );

      final GoogleSignInAccount? account =
      await googleSignIn.authenticate();

      if (account == null) {
        print('❌ Người dùng chưa đăng nhập');
        return;
      }

      final authClient = googleSignIn.authorizationClient;
      final scopes = ['email', 'https://www.googleapis.com/auth/youtube.force-ssl'];

      var authorization = await authClient.authorizationForScopes(scopes);
      authorization ??= await authClient.authorizeScopes(scopes);

      final accessToken = authorization.accessToken;

      if (accessToken.isEmpty) {
        print('❌ Không lấy được accessToken');
        return;
      }

      print('✅ Access Token: $accessToken');
      await CommonUtils().savePref("accessToken", accessToken);

      print('📧 Email: ${account.email}');
      await CommonUtils().savePref("email", account.email);

      print('📧 DisplayName: ${account.displayName}');
      await CommonUtils().savePref("displayName", account.displayName ?? '');

      print('📧 PhotoUrl: ${account.photoUrl}');
      await CommonUtils().savePref("photoUrl", account.photoUrl ?? '');

      await DB().insertUser(account.email);

      onSignedIn();
    } catch (e) {
      print('❌ Google Sign-In error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.folder, size: 128, color: Colors.black),
            const SizedBox(height: 16),
            Text(
              'Thưởng thức các video yêu thích của bạn',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: 'Nurito',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Đăng nhập để truy cập video bạn đã thích hoặc đã lưu',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontFamily: 'Nurito',
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => _handleSignIn(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Đăng nhập',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Nurito',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}