import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutoree_app/data/models/tutor_model.dart';
import 'package:tutoree_app/data/services/tutor_api_service.dart';

class TutorHomePage extends StatefulWidget {
  const TutorHomePage({super.key});

  @override
  State<TutorHomePage> createState() => _TutorHomePageState();
}

class _TutorHomePageState extends State<TutorHomePage> {
  int userId = 0;
  TutorApi apiService = TutorApi();
  List<Map<String, dynamic>> lists = [];
  bool _isApiLoading = true;
  bool _loadingIndicator = false;
  int selectedItem = -1;

  @override
  void initState() {
    super.initState();
    initStateMethods();
  }

  void initStateMethods() async {
    await getTokenData();
    await getStudentListForTutorDo(userId);
  }

  Future<void> getTokenData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = int.parse(prefs.getString("user_id").toString());
    });
  }

  Future<void> getStudentListForTutorDo(int tutorId) async {
    StudentList studentList = await apiService.getStudentListForTutor(tutorId);
    setState(() {
      lists.clear();
      lists.addAll(studentList.data);
      _isApiLoading = false;
    });
  }

  void switchLoadingIndicator() {
    setState(() {
      _loadingIndicator = !_loadingIndicator;
    });
  }

  Future<void> hideStudentReqDo(int studentId, int tutorId) async {
    // api integration
    switchLoadingIndicator();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
          onRefresh: () async {
            await getStudentListForTutorDo(userId);
          },
          color: Colors.black,
          child: _isApiLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('(${lists.length}) student requests...'),
                        const SizedBox(
                          height: 6.0,
                        ),
                        studentRequestListView(lists),
                      ],
                    ),
                  ),
                )),
    );
  }

  Widget studentRequestListView(List lists) {
    if (lists.isEmpty) {
      return Container(
        alignment: Alignment.center,
        child: const Text(
          'oops! looks like no requests available\nat this moment',
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
                  padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                  child: Text(
                    lists[index]["studentName"],
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                  child: Text(
                    '${lists[index]["email"]}\n${lists[index]["mobile_no"]}',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 14.0,
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
                        lists[index]["interests"],
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Color(0xFF616161),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 6, 20, 10),
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: lists[index]["tutorReqHide"] == 1
                          ? const Text(
                              'marked as done',
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
                                hideStudentReqDo(1, 1);
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
                                      'mark as done',
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
