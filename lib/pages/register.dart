import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutoree_app/config/constants.dart';
import 'package:tutoree_app/models/registration_model.dart';
import 'package:tutoree_app/pages/login.dart';
import 'package:tutoree_app/pages/otp.dart';
import 'package:tutoree_app/services/registration_api_service.dart';
import 'package:tutoree_app/utils/common_utils.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String selectedType = '';
  final fisrtnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final mobileNoController = TextEditingController();

  bool _showPassword = false;
  bool _loadingIndicator = false;
  var buttonColor = const Color(0xFFFFC8AC);

  /// Method to show/hide password (default:hide)
  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _stopLoadingIndicator() {
    setState(() {
      _loadingIndicator = false;
      buttonColor = const Color(0xFFFFC8AC);
    });
  }

  RegistrationApi registrationService = RegistrationApi();
  Registration? registerRequest;
  RegistrationResponse? registerRes;

  Future<void> registrationDo(
    String fname,
    String lname,
    String email,
    String pass,
    num mobile,
    String type,
  ) async {
    registerRes = await registrationService.register({
      "firstName": fname,
      "lastName": lname,
      "email": email,
      "password": pass,
      "mobileNo": mobile,
      "type": type,
      "status": registerRequest?.status,
      "isEmailVerified": registerRequest?.isEmailVerified,
      "isMobileVerified": registerRequest?.isMobileVerified,
      "createdOn": registerRequest?.createdOn,
      "modifiedOn": registerRequest?.modifiedOn,
    });
    _stopLoadingIndicator();
    if (registerRes?.statusCode == 500) {
      if (registerRes?.message == responseErrors['UNIQUE_mobile_no']) {
        errorSnackBar(
          alertDialog['registerErrorTitle']!,
          alertDialog['mobileNoExists']!,
        );
      } else if (registerRes?.message == responseErrors['UNIQUE_email']) {
        errorSnackBar(
          alertDialog['registerErrorTitle']!,
          alertDialog['emailExists']!,
        );
      }
    } else {
      Get.to(() => OtpPage(email: email));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 140, 0, 0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'let\'s get started \nwith registration...',
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
                    controller: fisrtnameController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22.0,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10.0),
                      hintText: 'firstname',
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
                      if (value == null || value.isEmpty) {
                        return textFieldErrors["mandatory"];
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
                    controller: lastnameController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22.0,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10.0),
                      hintText: 'lastname',
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
                      if (value == null || value.isEmpty) {
                        return textFieldErrors["mandatory"];
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
                      if (value!.length < 6) {
                        return 'Password must be atleast 6 characters';
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
                    controller: mobileNoController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22.0,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10.0),
                      hintText: 'mobile number',
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
                      if (value!.length != 10 || !value.isNumericOnly) {
                        return textFieldErrors["mobile"];
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  alignment: Alignment.center,
                  width: 350.0,
                  decoration: ShapeDecoration(
                      shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  )),
                  child: DropdownButton<String>(
                    iconSize: 36.0,
                    items: <String>[
                      'tutor',
                      'student',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontSize: 22.0,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                    hint: Container(
                      alignment: Alignment.center,
                      child: Text(
                        selectedType.isEmpty ? 'type' : selectedType,
                        style: const TextStyle(
                          color: Color(0xFF939393),
                          fontSize: 22.0,
                        ),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(30),
                    underline: const SizedBox(),
                    isExpanded: true,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedType = value;
                        });
                      }
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
                    minimumSize: const Size(130, 50),
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
                        registrationDo(
                          fisrtnameController.text,
                          lastnameController.text,
                          emailController.text,
                          passwordController.text,
                          num.parse(mobileNoController.text),
                          selectedType,
                        );
                      });
                    }
                  },
                  child: _loadingIndicator
                      ? Container(
                          height: 50,
                          width: 90,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                          child: loadingIndicator(),
                        )
                      : const Text(
                          'register',
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
                GestureDetector(
                  onTap: () {
                    Get.to(() => const LoginPage());
                  },
                  child: const Text(
                    'back to login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
