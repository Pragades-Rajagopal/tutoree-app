import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutoree_app/presentation/pages/feed/feed_list.dart';
import 'package:tutoree_app/presentation/pages/student/home.dart';
import 'package:tutoree_app/presentation/pages/student/profile.dart';

class StudentPage extends StatefulWidget {
  final int index;
  const StudentPage({
    super.key,
    required this.index,
  });

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
    setState(() {
      _currentIndex = widget.index;
    });
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
            vertical: 6.0,
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
                icon: Icons.newspaper_sharp,
                text: 'feeds',
              ),
              GButton(
                icon: Icons.account_circle_rounded,
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
      automaticallyImplyLeading: false,
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
