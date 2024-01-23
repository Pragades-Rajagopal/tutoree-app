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

class Logout {
  String? email;

  Logout({
    this.email,
  });
}

class LogoutResponse {
  int? statusCode;
  String? message;

  LogoutResponse({
    this.statusCode,
    this.message,
  });

  LogoutResponse.fromJson(Map<String, dynamic> response) {
    statusCode = response["statusCode"];
    message = response["message"];
  }
}

class DeactivationRequest {
  String? email;
  String? deviceType;

  DeactivationRequest({
    this.email,
    this.deviceType,
  });
}

class DeactivationResponse {
  int? statusCode;
  String? message;

  DeactivationResponse({
    this.statusCode,
    this.message,
  });

  DeactivationResponse.fromJson(Map<String, dynamic> response) {
    statusCode = response["statusCode"];
    message = response["message"];
  }
}
