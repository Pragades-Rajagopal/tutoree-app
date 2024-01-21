import 'package:tutoree_app/config/dotenv_config.dart';
import 'package:tutoree_app/data/models/login_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tutoree_app/config/constants.dart';

class LoginApi {
  Future<LoginResponse> login(Map<String, dynamic> data) async {
    final env = await accessENV(assetsFileName: '.env');
    var response = await http.post(
        Uri.parse('${env["URL"]}${endpoints["login"]}'),
        body: json.encode(data),
        headers: apiHeader);
    var body = jsonDecode(response.body);
    LoginResponse result = LoginResponse.fromJson(body);
    return result;
  }

  Future<ResetPasswordResponse> resetPasswordFunc(
      Map<String, dynamic> data) async {
    final env = await accessENV(assetsFileName: '.env');
    var response = await http.post(
        Uri.parse('${env["URL"]}${endpoints["resetPassword"]}'),
        body: json.encode(data),
        headers: apiHeader);
    var body = jsonDecode(response.body);
    ResetPasswordResponse result = ResetPasswordResponse.fromJson(body);
    return result;
  }

  Future<LogoutResponse> logout(Map<String, dynamic> data) async {
    final env = await accessENV(assetsFileName: '.env');
    var response = await http.post(
        Uri.parse('${env["URL"]}${endpoints["logout"]}'),
        body: json.encode(data),
        headers: apiHeader);
    var body = jsonDecode(response.body);
    LogoutResponse result = LogoutResponse.fromJson(body);
    return result;
  }
}
