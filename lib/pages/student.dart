import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutoree_app/pages/login.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  var _currentIndex = 0;
  Future<void> logoutDo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    Get.offAll(() => const LoginPage());
  }

  List<String> headers = [
    'home',
    'feeds',
    'profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        foregroundColor: Colors.black,
        title: Title(
          color: Colors.black,
          child: Text(
            headers[_currentIndex],
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  logoutDo();
                },
                child: const Text(
                  '< logout',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF2756FD),
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
}
