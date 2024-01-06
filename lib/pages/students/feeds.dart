import 'package:flutter/material.dart';

class StudentFeedsPage extends StatefulWidget {
  const StudentFeedsPage({super.key});

  @override
  State<StudentFeedsPage> createState() => _StudentFeedsPageState();
}

class _StudentFeedsPageState extends State<StudentFeedsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('This is the feeds page'),
          ],
        )),
      ),
    );
  }
}
