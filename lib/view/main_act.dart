import 'package:flutter/material.dart';
import 'package:my_youtube/view/ai_act.dart';
import 'package:my_youtube/view/home_frag.dart';
import 'package:my_youtube/view/my_account_fragment.dart';
import 'package:my_youtube/view/search_act.dart';
import 'package:my_youtube/view/subscriptions_frag.dart';

class MainAct extends StatefulWidget {
  const MainAct({Key? key}) : super(key: key);

  @override
  State<MainAct> createState() => _MainActState();
}

class _MainActState extends State<MainAct> {
  int _currentIndex = 0;

  final HomeFragment _homeFragment = HomeFragment();

  Widget _buildFragment(int index) {
    switch (index) {
      case 0:
        return _homeFragment;
      case 1:
        return SubscriptionsFrag();
      case 2:
        return MyAccountFragment();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/ic_logo.png', height: 38),
            SizedBox(width: 12),
            Text(
              'TechTube',
              style: TextStyle(
                fontFamily: 'Rocker',
                color: Colors.black,
                fontSize: 24,
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchAct()),
                );
              },
              icon: Icon(Icons.search, size: 32, color: Colors.black),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AIAct()),
                );
              },
              icon: Icon(Icons.psychology, size: 32, color: Colors.black),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: _buildFragment(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(fontSize: 11),
        selectedIconTheme: IconThemeData(size: 26),
        unselectedIconTheme: IconThemeData(size: 22),
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions),
            label: 'Subscriptions',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'You'),
        ],
      ),
    );
  }
}
