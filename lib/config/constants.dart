import 'package:flutter/material.dart';

Map<String, String> endpoints = {
  "login": "/api/login",
  "user": "/api/users",
  "otp": "/api/validate-otp",
};

Map<String, String> apiHeader = {
  'Content-type': 'application/json',
  'Accept': 'application/json'
};

Map<String, String> alertDialog = {
  'IncorrectPassword': 'please enter the correct password',
  'passwordCharacter': 'password must be atleast 6 characters',
  'loginErrorTitle': 'login error',
  'userNotRegistered': 'user not registered or OTP not verified',
  'registerErrorTitle': 'registration error',
  'mobileNoExists': 'mobile number already exists',
  'emailNotExists': 'email does not exists',
  'emailExists': 'email already exists',
  'otpNotValidated': 'OTP not validated',
};

Map<String, String> responseErrors = {
  'UNIQUE_mobile_no': 'UNIQUE constraint failed: users.mobile_no',
  'UNIQUE_email': 'UNIQUE constraint failed: users.email',
};

Map<String, String> textFieldErrors = {
  'email': 'email is mandatory',
  'mobile': 'mobile number is mandatory with 10 digits',
  'password': 'password is mandatory with greater than 6 characters',
  'mandatory': 'this field is mandatory',
  'otp_mandatory': 'enter 4 digit otp',
};

var enabledBorder_ = OutlineInputBorder(
  borderRadius: BorderRadius.circular(30.0),
  borderSide: const BorderSide(
    color: Colors.black,
    width: 2.0,
  ),
);
var focusedBorder_ = OutlineInputBorder(
  borderRadius: BorderRadius.circular(30.0),
  borderSide: const BorderSide(
    color: Colors.black,
    width: 2.0,
  ),
);

var errorBorder_ = OutlineInputBorder(
  borderRadius: BorderRadius.circular(30.0),
  borderSide: const BorderSide(
    color: Color(0xFFFF0000),
    width: 2.0,
  ),
);
