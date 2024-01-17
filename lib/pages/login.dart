import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutoree_app/config/constants.dart';
import 'package:tutoree_app/models/login_model.dart';
import 'package:tutoree_app/pages/register.dart';
import 'package:tutoree_app/pages/reset_password.dart';
import 'package:tutoree_app/pages/student.dart';
import 'package:tutoree_app/pages/tutor.dart';
import 'package:tutoree_app/services/login_api_service.dart';
import 'package:tutoree_app/utils/common_utils.dart';
import 'package:tutoree_app/utils/token_validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? userType;
  String? userName;
  String? userEmail;
  int? userId;

  bool _showPassword = false;
  bool _loadingIndicator = false;
  var buttonColor = const Color(0xFFACBEFF);

  /// Method to show/hide password (default:hide)
  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _stopLoadingIndicator() {
    setState(() {
      _loadingIndicator = false;
      buttonColor = const Color(0xFFACBEFF);
    });
  }

  void parseToken(String? token) {
    final payloadData = parseJwtPayLoad(token!);
    userType = payloadData["_type"];
    userEmail = payloadData["email"];
    userName = payloadData["username"];
    userId = payloadData["id"];
  }

  LoginApi loginService = LoginApi();
  Login? loginRequest;
  LoginResponse? loginRes;

  Future<void> loginDo(String email, String password) async {
    loginRes = await loginService.login({
      "email": email,
      "password": password,
    });
    _stopLoadingIndicator();
    if (loginRes?.statusCode == 200) {
      // Setting token
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = loginRes?.token;
      await pref.setString('token', token!);
      // Setting user info
      parseToken(loginRes!.token);
      await pref.setString('user_type', userType!);
      await pref.setString('user_email', userEmail!);
      await pref.setString('user_name', userName!);
      await pref.setString('user_id', userId.toString());
      // Redirect based on user type
      userType == 'tutor'
          ? Get.offAll(() => const TutorPage())
          : Get.offAll(() => const StudentPage(index: 0));
    } else if (loginRes?.statusCode == 401) {
      errorSnackBar(
        alertDialog['loginErrorTitle']!,
        alertDialog['IncorrectPassword']!,
      );
      throw Exception(loginRes?.message);
    } else if (loginRes?.statusCode == 404) {
      errorSnackBar(
        alertDialog['loginErrorTitle']!,
        alertDialog['userNotRegistered']!,
      );
      throw Exception(loginRes?.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get.offAll(() => const TutorPage());
    // Get.offAll(() => const StudentPage());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: _formKey,
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
                height: 20.0,
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
                    enabledBorder: enabledBorder_,
                    focusedBorder: focusedBorder_,
                    errorBorder: errorBorder_,
                    focusedErrorBorder: focusedBorder_,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.isEmail) {
                      return textFieldErrors["email"];
                    }
                    return null;
                  },
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
                    enabledBorder: enabledBorder_,
                    focusedBorder: focusedBorder_,
                    errorBorder: errorBorder_,
                    focusedErrorBorder: focusedBorder_,
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
                    if (value == null || value.length < 6) {
                      return textFieldErrors["password"];
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black87,
                  backgroundColor: buttonColor,
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
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _loadingIndicator = true;
                      buttonColor = Colors.white;
                      loginRequest?.email = emailController.text;
                      loginRequest?.password = passwordController.text;
                      loginDo(emailController.text, passwordController.text);
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
                height: 14.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const Register());
                    },
                    child: const Text(
                      'register',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 21,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Container(
                    color: Colors.black45,
                    height: 21,
                    width: 2,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const ResetPasswordPage());
                    },
                    child: const Text(
                      'forgot password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 21,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
