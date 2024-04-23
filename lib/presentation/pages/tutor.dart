import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutoree_app/presentation/pages/feed/feed_list.dart';
import 'package:tutoree_app/presentation/pages/search.dart';
import 'package:tutoree_app/presentation/pages/tutor/home.dart';
import 'package:tutoree_app/presentation/pages/tutor/profile.dart';
import 'package:tutoree_app/presentation/utils/common_utils.dart';

class TutorPage extends StatefulWidget {
  final int index;
  const TutorPage({
    super.key,
    required this.index,
  });

  @override
  State<TutorPage> createState() => _TutorPageState();
}

class _TutorPageState extends State<TutorPage> {
  late PageController _pageController = PageController();
  String? userName;
  var _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    getTokenData();
    setState(() {
      _currentIndex = widget.index;
      _pageController = PageController(initialPage: _currentIndex);
    });
  }

  void getTokenData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("user_name");
    });
  }

  static final List<Widget> _widget = [
    const TutorHomePage(),
    const CommonFeedsPage(),
    const SearchPage(),
    const TutorProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: PageView(
        physics: const BouncingScrollPhysics(),
        controller: _pageController,
        children: _widget,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          elevation: 0,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey.shade500,
          iconSize: 24.0,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12.0,
          unselectedFontSize: 12.0,
          items: bottomNavBar,
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
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w100,
          ),
        ),
      ),
      // centerTitle: true,
    );
  }
}
