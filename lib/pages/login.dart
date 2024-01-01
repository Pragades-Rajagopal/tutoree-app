import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutoree_app/config/constants.dart';
import 'package:tutoree_app/models/login_model.dart';
import 'package:tutoree_app/pages/register.dart';
import 'package:tutoree_app/pages/tutor_list.dart';
import 'package:tutoree_app/services/login_api_service.dart';
import 'package:tutoree_app/utils/common_utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _showPassword = false;

  /// Method to show/hide password (default:hide)
  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  LoginApi loginService = LoginApi();
  Login? loginRequest;
  LoginResponse? loginRes;

  Future<void> loginDo(String email, String password) async {
    loginRes = await loginService.login({
      "email": email,
      "password": password,
    });
    if (loginRes?.statusCode == 200) {
      Get.to(() => const TutorList());
    } else if (loginRes?.statusCode == 401) {
      alterDialog(
        alertDialog['loginErrorTitle']!,
        alertDialog['IncorrectPassword']!,
      );
      throw Exception(loginRes?.message);
    } else if (loginRes?.statusCode == 404) {
      alterDialog(
        alertDialog['loginErrorTitle']!,
        alertDialog['userNotRegistered']!,
      );
      throw Exception(loginRes?.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'tutoree',
              style: TextStyle(
                color: Colors.black,
                fontSize: 40,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Text(
              'where students meet the right teacher',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            SizedBox(
              width: 350.0,
              // height: 100.0,
              child: TextFormField(
                controller: emailController,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22.0,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10.0),
                  hintText: 'email',
                  hintStyle: const TextStyle(
                    color: Color(0xFF939393),
                    fontSize: 22.0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              width: 350.0,
              // height: 100.0,
              child: TextFormField(
                controller: passwordController,
                textAlign: TextAlign.center,
                obscureText: !_showPassword,
                obscuringCharacter: '*',
                enableSuggestions: false,
                autocorrect: false,
                style: const TextStyle(
                  fontSize: 22.0,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10.0),
                  hintText: '       password',
                  hintStyle: const TextStyle(
                    color: Color(0xFF939393),
                    fontSize: 22.0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _togglePasswordVisibility();
                    },
                    child: Icon(
                      _showPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_sharp,
                      color: Colors.black,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value!.length < 6) {
                    return alertDialog['passwordCharacter']!;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black87,
                backgroundColor: const Color(0xFFACBEFF),
                minimumSize: const Size(100, 50),
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
                setState(() {
                  loginRequest?.email = emailController.text;
                  loginRequest?.password = passwordController.text;
                  loginDo(emailController.text, passwordController.text);
                });
              },
              child: const Text(
                'login',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => const Register());
              },
              child: const Text(
                'register >',
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
          ],
        ),
      ),
    );
  }
}
