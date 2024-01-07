import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutoree_app/config/constants.dart';
import 'package:tutoree_app/models/student_model.dart';
import 'package:tutoree_app/services/student_api_service.dart';
import 'package:tutoree_app/utils/common_utils.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  int userId = 0;
  StudentApi apiService = StudentApi();
  List<Map<String, dynamic>> lists = [];
  TutorRequestResponse? tutorReqRes;

  @override
  void initState() {
    super.initState();
    initStateMethods();
  }

  /// Initiating fetch token data from local storage
  /// and tutor list for the student based on interests
  void initStateMethods() async {
    await getTokenData();
    await getTutorListDo(userId);
  }

  Future<void> getTokenData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = int.parse(prefs.getString("user_id").toString());
    });
  }

  Future<void> getTutorListDo(int studentId) async {
    TutorList tutorList = await apiService.getTutorlist(studentId);
    setState(() {
      lists.addAll(tutorList.data);
    });
  }

  Future<void> sendTutorRequestDo(int studentId, int tutorId) async {
    print('called');
    tutorReqRes = await apiService.sendTutorRequest({
      "studentId": studentId,
      "tutorId": tutorId,
    });
    if (tutorReqRes!.statusCode == 400) {
      errorSnackBar(
        alertDialog['relax']!,
        alertDialog['tutorReqExists']!,
      );
    } else if (tutorReqRes!.statusCode == 500) {
      errorSnackBar(
        alertDialog['oops']!,
        alertDialog['tutorReqError']!,
      );
    } else if (tutorReqRes!.statusCode == 200) {
      successSnackBar(
        alertDialog['commonSuccess']!,
        alertDialog['tutorReqSuccess']!,
      );
    }
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
            children: [
              Text('(${lists.length}) tutors based on your interests...'),
              const SizedBox(
                height: 6.0,
              ),
              tutorListView(lists),
            ],
          ),
        ),
      ),
    );
  }
}

Widget tutorListView(List lists) {
  if (lists.isEmpty) {
    return Container(
      alignment: Alignment.center,
      child: const Text(
        'oops! looks like no tutors available\nat this moment',
        style: TextStyle(
          fontSize: 12.0,
          color: Colors.grey,
        ),
        textAlign: TextAlign.center,
      ),
    );
  } else {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: lists.length,
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
          child: ExpansionTile(
            collapsedIconColor: Colors.black,
            iconColor: Colors.grey,
            title: Text(
              lists[index]["tutorName"],
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Text(
                lists[index]["bio"],
                style: const TextStyle(
                  fontSize: 12.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.black,
                ),
              ),
            ),
            children: <Widget>[
              const Divider(
                thickness: 1.0,
                height: 1.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    lists[index]["courses"],
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Color(0xFF616161),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    lists[index]["websites"],
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Color(0xFF616161),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 6, 20, 10),
                child: Container(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      // call sendTutorRequestDo method
                    },
                    child: const Text(
                      'request',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(255, 92, 80, 255),
                        fontSize: 18.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
