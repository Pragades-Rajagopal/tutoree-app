import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutoree_app/config/constants.dart';
import 'package:tutoree_app/models/login_model.dart';
import 'package:tutoree_app/models/registration_model.dart';
import 'package:tutoree_app/pages/login.dart';
import 'package:tutoree_app/services/login_api_service.dart';
import 'package:tutoree_app/services/registration_api_service.dart';
import 'package:tutoree_app/utils/common_utils.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final GlobalKey<FormState> key_ = GlobalKey<FormState>();
  final _formFieldKey = GlobalKey<FormFieldState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final otpController = TextEditingController();
  bool _showPassword = false;

  /// Method to show/hide password (default:hide)
  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  OtpApi otpService = OtpApi();
  ResendOTPResponse? otpResponse;
  LoginApi loginService = LoginApi();
  ResetPasswordResponse? resetPassRes;

  Future<void> resendOtpDo(String email) async {
    otpResponse = await otpService.sendOtp({
      "email": email,
    });
    if (otpResponse!.statusCode == 500) {
      errorSnackBar(
        alertDialog['oops']!,
        alertDialog['commonError']!,
      );
    } else if (otpResponse!.statusCode == 404) {
      errorSnackBar(
        alertDialog['oops']!,
        alertDialog['emailNotExistsOrUnregistered']!,
      );
    } else if (otpResponse!.statusCode == 200) {
      successSnackBar(
        alertDialog['commonSuccess']!,
        alertDialog['emailSent']!,
      );
    }
  }

  Future<void> resetPasswordDo(
      String email, String password, String otp) async {
    resetPassRes = await loginService.resetPasswordFunc({
      "email": email,
      "password": password,
      "otp": otp,
    });
    if (resetPassRes!.statusCode == 404) {
      errorSnackBar(
        alertDialog['oops']!,
        alertDialog['emailNotExists']!,
      );
    } else if (resetPassRes!.statusCode == 400) {
      errorSnackBar(
        alertDialog['oops']!,
        alertDialog['otpNotValidated']!,
      );
    } else if (resetPassRes!.statusCode == 200) {
      successSnackBar(
        alertDialog['passResetSuccess']!,
        alertDialog['rerouteLoginPage']!,
      );
      Future.delayed(const Duration(seconds: 2), () {
        Get.to(() => const LoginPage());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: key_,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'reset password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 350.0,
                child: TextFormField(
                  key: _formFieldKey,
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
                    hintText: '       new password',
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
                      return textFieldErrors["password"];
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 140.0,
                    // height: 100.0,
                    child: TextFormField(
                      controller: otpController,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22.0,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10.0),
                        hintText: '****',
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
                        if (value!.length != 4 || !value.isNumericOnly) {
                          return textFieldErrors["otp_mandatory"];
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_formFieldKey.currentState!.validate()) {
                        resendOtpDo(emailController.text);
                      }
                    },
                    child: const Text(
                      'send otp',
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
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  backgroundColor: const Color.fromARGB(255, 172, 255, 186),
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
                  if (key_.currentState!.validate()) {
                    setState(() {
                      resetPasswordDo(
                        emailController.text,
                        passwordController.text,
                        otpController.text,
                      );
                    });
                  }
                },
                child: const Text(
                  'submit',
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
            ],
          ),
        ),
      ),
    );
  }
}
