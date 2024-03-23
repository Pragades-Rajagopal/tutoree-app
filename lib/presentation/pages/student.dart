import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutoree_app/presentation/pages/feed/feed_list.dart';
import 'package:tutoree_app/presentation/pages/student/home.dart';
import 'package:tutoree_app/presentation/pages/student/profile.dart';
import 'package:tutoree_app/presentation/utils/common_utils.dart';

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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        elevation: 0,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey.shade500,
        iconSize: 24.0,
        type: BottomNavigationBarType.fixed,
        items: bottomNavBar,
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
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
