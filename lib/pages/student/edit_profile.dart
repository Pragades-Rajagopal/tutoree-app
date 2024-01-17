import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutoree_app/config/constants.dart';
import 'package:tutoree_app/models/common_model.dart';
import 'package:tutoree_app/models/student_model.dart';
import 'package:tutoree_app/services/common_api_service.dart';
import 'package:tutoree_app/services/student_api_service.dart';
import 'package:tutoree_app/utils/common_utils.dart';

class StudentEditProfilePage extends StatefulWidget {
  const StudentEditProfilePage({super.key});

  @override
  State<StudentEditProfilePage> createState() => _StudentEditProfilePageState();
}

class _StudentEditProfilePageState extends State<StudentEditProfilePage> {
  int userId = 0;
  List<Course> courseList = [];
  CourseApi courseApiService = CourseApi();
  List<int> selectCourses = [];
  StudentApi studentApiService = StudentApi();
  PostStudentInterestRes? interestRes;

  @override
  void initState() {
    super.initState();
    initStateMethods();
  }

  void initStateMethods() async {
    getTokenData();
    await getCourseListDo();
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
        padding: const EdgeInsets.fromLTRB(10, 80, 10, 40),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('select courses'),
              SizedBox(
                width: 350,
                child: MultiSelectDialogField(
                  title: const Text('select courses'),
                  searchable: true,
                  items: courseList
                      .map((e) => MultiSelectItem(e.id, e.name))
                      .toList(),
                  listType: MultiSelectListType.CHIP,
                  onConfirm: (values) {
                    selectCourses = values;
                    addInterestsDo(userId, selectCourses);
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Add'),
            ],
          ),
        ),
      ),
    );
  }
}
