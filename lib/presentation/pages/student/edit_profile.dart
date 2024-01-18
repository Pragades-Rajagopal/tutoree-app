import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutoree_app/config/constants.dart';
import 'package:tutoree_app/data/models/common_model.dart';
import 'package:tutoree_app/data/models/student_model.dart';
import 'package:tutoree_app/data/services/common_api_service.dart';
import 'package:tutoree_app/data/services/student_api_service.dart';
import 'package:tutoree_app/presentation/utils/common_utils.dart';

class StudentEditProfilePage extends StatefulWidget {
  final List<int> studentInterests;
  const StudentEditProfilePage({
    super.key,
    required this.studentInterests,
  });

  @override
  State<StudentEditProfilePage> createState() => _StudentEditProfilePageState();
}

class _StudentEditProfilePageState extends State<StudentEditProfilePage> {
  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();
  int userId = 0;
  List<Course> courseList = [];
  CourseApi courseApiService = CourseApi();
  List<int> selectCourses = [];
  StudentApi studentApiService = StudentApi();
  PostStudentInterestRes? interestRes;
  bool _loadingIndicator = false;
  var _buttonColor = Colors.black;

  @override
  void initState() {
    super.initState();
    initStateMethods();
  }

  void initStateMethods() async {
    getTokenData();
    await getCourseListDo();
  }

  void _stopLoadingIndicator() {
    setState(() {
      _loadingIndicator = false;
      _buttonColor = Colors.black;
    });
  }

  void getTokenData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = int.parse(prefs.getString("user_id").toString());
    });
  }

  Future<void> getCourseListDo() async {
    List<Course> data = await courseApiService.getCourseList();
    setState(() {
      courseList.addAll(data);
    });
  }

  Future<void> addInterestsDo(int studentId, List<int> courseIds) async {
    interestRes = await studentApiService.addInterests({
      "studentId": studentId,
      "courseIds": courseIds,
    });
    if (interestRes?.statusCode == 400) {
      errorSnackBar(
        alertDialog['oops']!,
        alertDialog['addIntrstCheckError']!,
      );
    } else if (interestRes?.statusCode == 500) {
      errorSnackBar(
        alertDialog['oops']!,
        alertDialog['commonError']!,
      );
    } else if (interestRes?.statusCode == 200) {
      _stopLoadingIndicator();
      successSnackBar(
        alertDialog['commonSuccess']!,
        alertDialog['interestAdded']!,
      );
      Get.offAndToNamed('studentHomeProfile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10, 90, 10, 40),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 350,
                child: MultiSelectDialogField(
                  title: const Text('select interests'),
                  buttonText: const Text('select interests'),
                  key: _key,
                  searchable: true,
                  selectedColor: Colors.black54,
                  selectedItemsTextStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  items: courseList
                      .map((e) => MultiSelectItem(e.id, e.name))
                      .toList(),
                  listType: MultiSelectListType.CHIP,
                  initialValue: widget.studentInterests,
                  onConfirm: (values) {
                    selectCourses = values;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return textFieldErrors["add_interest_mandatory"];
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: _buttonColor,
                  minimumSize: const Size(100, 40),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                  ),
                ),
                onPressed: () {
                  if (_key.currentState!.validate()) {
                    setState(() {
                      _loadingIndicator = true;
                      _buttonColor = Colors.white;
                      addInterestsDo(userId, selectCourses);
                    });
                  }
                },
                child: _loadingIndicator
                    ? Container(
                        height: 50,
                        width: 60,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        child: loadingIndicator(),
                      )
                    : const Text(
                        'update',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
