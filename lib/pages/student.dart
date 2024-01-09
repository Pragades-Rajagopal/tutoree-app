import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutoree_app/pages/feed/feed_list.dart';
import 'package:tutoree_app/pages/student/home.dart';
import 'package:tutoree_app/pages/student/profile.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  String? userName;
  var _currentIndex = 0;
  List<String> headers = [
    'home',
    'feeds',
    'profile',
  ];

  @override
  void initState() {
    super.initState();
    getTokenData();
  }

  void getTokenData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("user_name");
    });
  }

  static final List<Widget> _widget = [
    const StudentHomePage(),
    const CommonFeedsPage(),
    const StudentProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: _widget[_currentIndex],
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50.0,
            vertical: 10.0,
          ),
          child: GNav(
            selectedIndex: _currentIndex,
            onTabChange: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor: Colors.white,
            color: Colors.black,
            activeColor: Colors.black,
            tabBackgroundColor: Colors.grey.shade300,
            padding: const EdgeInsets.all(12.0),
            gap: 1,
            tabs: const [
              GButton(
                icon: Icons.home_filled,
                text: 'home',
              ),
              GButton(
                icon: Icons.markunread_mailbox_rounded,
                text: 'feeds',
              ),
              GButton(
                icon: Icons.manage_accounts_rounded,
                text: 'profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      foregroundColor: Colors.black,
      title: Title(
        color: Colors.black,
        child: Text(
          "Welcome, $userName",
        ),
      ),
      // centerTitle: true,
    );
  }
}
