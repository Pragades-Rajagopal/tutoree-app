import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutoree_app/config/constants.dart';
import 'package:tutoree_app/data/models/student_model.dart';
import 'package:tutoree_app/data/services/student_api_service.dart';
import 'package:tutoree_app/presentation/utils/common_utils.dart';

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
  bool _loadingIndicator = false;
  int selectedItem = -1;
  bool _isApiLoading = true;

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
      _isApiLoading = false;
    });
  }

  Future<void> sendTutorRequestDo(int studentId, int tutorId) async {
    tutorReqRes = await apiService.sendTutorRequest({
      "studentId": studentId,
      "tutorId": tutorId,
    });
    switchLoadingIndicator();
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

  void switchLoadingIndicator() {
    setState(() {
      _loadingIndicator = !_loadingIndicator;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isApiLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            )
          : SingleChildScrollView(
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

  Widget tutorListView(List lists) {
    if (lists.isEmpty) {
      return Container(
        alignment: Alignment.center,
        child: const Text(
          'oops! looks like no tutors available\nat this moment\n\ntry adding some interests in profile',
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
            child: Theme(
              data: ThemeData(
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                collapsedIconColor: Colors.black,
                iconColor: Colors.grey,
                backgroundColor: Colors.grey.shade50,
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                  child: Text(
                    lists[index]["tutorName"],
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                  child: Text(
                    '${lists[index]["bio"]}\n${lists[index]["websites"]}',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 12.0,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF616161),
                      ),
                    ),
                  ),
                ),
                children: <Widget>[
                  const Divider(
                    thickness: 1.0,
                    height: 1.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        lists[index]["courses"],
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Color(0xFF3C3C3C),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 6, 20, 10),
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: lists[index]["tutorReqStatus"] == 1
                          ? const Text(
                              'requested',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromRGBO(189, 189, 189, 1),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  _loadingIndicator = true;
                                  selectedItem = index;
                                });
                                sendTutorRequestDo(
                                    userId, lists[index]["tutorId"]);
                              },
                              child: _loadingIndicator && selectedItem == index
                                  ? const SizedBox(
                                      height: 21,
                                      width: 21,
                                      child: CircularProgressIndicator(
                                        color: Colors.black,
                                        strokeWidth: 2.0,
                                        strokeCap: StrokeCap.square,
                                      ),
                                    )
                                  : const Text(
                                      'request',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 92, 80, 255),
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
