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
