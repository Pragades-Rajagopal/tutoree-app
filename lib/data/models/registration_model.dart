class Registration {
  String? firstname;
  String? lastname;
  String? email;
  String? password;
  num? mobileNo;
  int isEmailVerified = 0;
  int isMobileVerified = 0;
  String? type;
  int status = 0;
  String createdOn = '';
  String modifiedOn = '';

  Registration({
    this.firstname,
    this.lastname,
    this.email,
    this.password,
    this.mobileNo,
    this.type,
  });
}

class RegistrationResponse {
  int? statusCode;
  int? id;
  String? message;

  RegistrationResponse({
    this.id,
    this.statusCode,
    this.message,
  });

  RegistrationResponse.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    statusCode = json["statusCode"];
    message = json["message"];
  }
}

class OTP {
  String? email;
  String? pin;

  OTP({
    this.email,
    this.pin,
  });
}

class OTPresponse {
  int? statusCode;
  String? message;

  OTPresponse({
    this.statusCode,
    this.message,
  });

  OTPresponse.fromJson(Map<String, dynamic> json) {
    statusCode = json["statusCode"];
    message = json["message"];
  }
}

class ResendOTPResponse {
  int? statusCode;
  String? message;
  String? error;

  ResendOTPResponse({
    this.statusCode,
    this.message,
    this.error,
  });

  ResendOTPResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json["statusCode"];
    message = json["message"];
    error = json["error"];
  }
}
