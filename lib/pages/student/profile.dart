import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutoree_app/models/student_model.dart';
import 'package:tutoree_app/pages/login.dart';
import 'package:tutoree_app/services/student_api_service.dart';

class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({super.key});

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  int _userId = 0;
  StudentApi apiService = StudentApi();
  StudentProfile? studentProfile;
  List interests = [];
  List feeds = [];
  String _interestsHeader = 'no interests! try adding some courses';

  @override
  void initState() {
    super.initState();
    getTokenData();
  }

  void getTokenData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = int.parse(prefs.getString("user_id").toString());
    });
    getStudentProfileDo(_userId);
  }

  Future<void> getStudentProfileDo(int userId) async {
    studentProfile = await apiService.getStudentProfile(userId);
    setState(() {
      feeds.addAll(studentProfile!.feeds);
      interests.addAll(studentProfile!.interests);
    });
    _changeInterestHeader();
  }

  Future<void> logoutDo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    Get.offAll(() => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                child: Text(
                  '${studentProfile?.email}',
                  style: const TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 6, 0, 0),
                child: Text(
                  '${studentProfile?.mobileNum}',
                  style: const TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                child: Text(
                  '*this mobile number will be sent to the requested tutors',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
              ),
              Container(
                height: 0.8,
                width: 1000.0,
                alignment: Alignment.center,
                color: Colors.grey.shade400,
                margin: const EdgeInsets.fromLTRB(4, 8, 4, 8),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                child: Text(
                  _interestsHeader,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Color(0xFF616161),
                  ),
                ),
              ),
              Wrap(
                children: List<Widget>.generate(
                  interests.length,
                  (int index) {
                    return SizedBox(
                      height: 42.0,
                      child: Chip(
                        label: Text(
                          interests[index]["courseName"],
                          style: const TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                        backgroundColor: Colors.grey.shade200,
                      ),
                    );
                  },
                ).toList(),
              ),
              Container(
                height: 0.8,
                width: 1000.0,
                alignment: Alignment.center,
                color: Colors.grey.shade400,
                margin: const EdgeInsets.fromLTRB(4, 8, 4, 8),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                child: Text(
                  'feeds (${feeds.length})',
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Color(0xFF616161),
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: feeds.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 2.0,
                      vertical: 5.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    shadowColor: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Text(
                              feeds[index]["content"],
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.grey.shade100,
                            height: 2,
                            width: 350,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                feeds[index]["created_by"],
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: Color(0xFF757575),
                                ),
                              ),
                              Text(
                                feeds[index]["date_"],
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: Color(0xFF757575),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Container(
                height: 0.5,
                width: 1000.0,
                alignment: Alignment.center,
                color: Colors.grey.shade400,
                margin: const EdgeInsets.fromLTRB(4, 24, 4, 8),
              ),
              GestureDetector(
                onTap: () {
                  logoutDo();
                },
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                  child: Text(
                    'logout',
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
              ),
              const SizedBox(
                height: 20.0,
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Method to change the interest header
  /// based on interest count
  void _changeInterestHeader() {
    if (interests.isEmpty) {
      setState(() {
        _interestsHeader = _interestsHeader;
      });
    } else {
      setState(() {
        _interestsHeader = 'interests (${interests.length})';
      });
    }
  }
}
