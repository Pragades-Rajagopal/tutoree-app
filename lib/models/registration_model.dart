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
