import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutoree_app/config/constants.dart';
import 'package:tutoree_app/data/models/registration_model.dart';
import 'package:tutoree_app/presentation/pages/login.dart';
import 'package:tutoree_app/data/services/registration_api_service.dart';
import 'package:tutoree_app/presentation/utils/common_utils.dart';

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
  var buttonColor = const Color.fromARGB(255, 214, 172, 255);
  bool _loadingIndicator = false;

  void switchLoadingIndicator() {
    setState(() {
      _loadingIndicator = false;
      buttonColor = const Color.fromARGB(255, 214, 172, 255);
    });
  }

  OtpApi otpApiService = OtpApi();
  OTP? otpReq;
  OTPresponse? otpRes;
  OtpApi otpService = OtpApi();
  ResendOTPResponse? otpResponse;

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

  Future<void> validateOtpDo(String email, String otp) async {
    otpRes = await otpApiService.register({
      "email": email,
      "pin": otp,
    });
    switchLoadingIndicator();
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
                      validateOtpDo(widget.email, otpController.text);
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
                height: 14.0,
              ),
              GestureDetector(
                onTap: () {
                  resendOtpDo(widget.email);
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
