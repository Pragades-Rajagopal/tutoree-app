class Login {
  String? email;
  String? password;

  Login({
    this.email,
    this.password,
  });
}

class LoginResponse {
  int? statusCode;
  String? message;
  String? token;

  LoginResponse({
    this.statusCode,
    this.message,
    this.token,
  });

  LoginResponse.fromJson(Map<String, dynamic> response) {
    statusCode = response["statusCode"];
    message = response["message"];
    token = response["token"];
  }
}

class ResetPassword {
  String? email;
  String? otp;
  String? password;

  ResetPassword({
    this.email,
    this.otp,
    this.password,
  });
}

class ResetPasswordResponse {
  int? statusCode;
  String? message;

  ResetPasswordResponse({
    this.statusCode,
    this.message,
  });

  ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json["statusCode"];
    message = json["message"];
  }
}
