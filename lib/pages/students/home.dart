import 'package:flutter/material.dart';
import 'package:tutoree_app/models/student_model.dart';
import 'package:tutoree_app/services/student_api_service.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  StudentApi apiService = StudentApi();
  List<Map<String, dynamic>> lists = [];

  @override
  void initState() {
    super.initState();
    getTutorListDo(1);
  }

  Future<void> getTutorListDo(int studentId) async {
    TutorList tutorList = await apiService.getTutorlist(studentId);
    setState(() {
      lists.addAll(tutorList.data);
    });
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
            horizontal: 2,
            vertical: 6,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: Colors.grey.shade500,
              width: 1.5,
            ),
          ),
          shadowColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.fromLTRB(15, 6, 15, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lists[index]["tutorName"],
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        lists[index]["bio"],
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 4.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'request',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(255, 51, 0, 255),
                          fontSize: 16.0,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
