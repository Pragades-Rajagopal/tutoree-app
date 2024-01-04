import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutoree_app/config/constants.dart';
import 'package:tutoree_app/models/registration_model.dart';
import 'package:tutoree_app/pages/login.dart';
import 'package:tutoree_app/services/registration_api_service.dart';
import 'package:tutoree_app/utils/common_utils.dart';

class OtpPage extends StatefulWidget {
  final String email;
  const OtpPage({
    super.key,
    required this.email,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final otpController = TextEditingController();

  OtpApi otpApiService = OtpApi();
  OTP? otpReq;
  OTPresponse? otpRes;

  Future<void> validateOtpDo(String email, String otp) async {
    otpRes = await otpApiService.register({
      "email": email,
      "pin": otp,
    });
    if (otpRes?.statusCode == 404) {
      errorSnackBar(
        alertDialog['registerErrorTitle']!,
        alertDialog['emailNotExists']!,
      );
    } else if (otpRes?.statusCode == 400) {
      errorSnackBar(
        alertDialog['registerErrorTitle']!,
        alertDialog['otpNotValidated']!,
      );
    } else {
      successSnackBar(
        alertDialog['otpValidated']!,
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
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'OTP is sent to below email...\n"${widget.email}"',
                textAlign: TextAlign.center,
                style: const TextStyle(
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
                height: 20.0,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  backgroundColor: const Color.fromARGB(255, 214, 172, 255),
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
                      validateOtpDo(widget.email, otpController.text);
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
              GestureDetector(
                onTap: () {
                  // create func and trigger otp
                },
                child: const Text(
                  'resend otp',
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
      ),
    );
  }
}
