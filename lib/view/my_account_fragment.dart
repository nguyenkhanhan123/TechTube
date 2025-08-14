import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_youtube/common_utils.dart';
import 'package:my_youtube/view/detail_account_fragment.dart';
import 'package:my_youtube/view/signin_fragment.dart';

class MyAccountFragment extends StatefulWidget {
  @override
  State<MyAccountFragment> createState() => _MyAccountFragmentState();
}

class _MyAccountFragmentState extends State<MyAccountFragment> {
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    _checkSignedIn();
  }

  Future<void> _checkSignedIn() async {
    String? token = await CommonUtils().getPref("accessToken");
    print(token);
    if (token != null && token.isNotEmpty) {
      setState(() {
        _isSignedIn = true;
      });
    }
  }

  void _onSignInSuccess() {
    setState(() {
      _isSignedIn = true;
    });
  }

  void _onSignOut() {
    setState(() {
      _isSignedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isSignedIn ? DetailAccount(onSignOut: _onSignOut) : SignIn(onSignedIn: _onSignInSuccess);
  }
}


