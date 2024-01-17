import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutoree_app/pages/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tutoree_app/pages/student.dart';
import 'package:tutoree_app/pages/tutor.dart';

String? token;
String? userType;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  token = prefs.getString("token");
  userType = prefs.getString("user_type");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          bodyLarge: GoogleFonts.poppins(),
          bodyMedium: GoogleFonts.poppins(),
          bodySmall: GoogleFonts.poppins(),
        ),
      ),
      initialRoute: token == null ? "/" : "user",
      routes: {
        "user": (context) => userType == 'tutor'
            ? const TutorPage()
            : const StudentPage(index: 0),
        "/": (context) => const LoginPage(),
        "studentHomeFeed": (context) => const StudentPage(index: 1),
        "studentHomeProfile": (context) => const StudentPage(index: 2),
        "tutorHome": (context) => const TutorPage(),
      },
    );
  }
}
