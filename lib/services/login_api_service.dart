import 'package:tutoree_app/config/dotenv_config.dart';
import 'package:tutoree_app/models/login_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tutoree_app/config/constants.dart';

const header = {
  'Content-type': 'application/json',
  'Accept': 'application/json'
};

class LoginApi {
  Future<LoginResponse> login(Map<String, dynamic> data) async {
    final env = await accessENV(assetsFileName: '.env');
    var response = await http.post(
        Uri.parse('${env["URL"]}${endpoints["login"]}'),
        body: json.encode(data),
        headers: header);
    var body = jsonDecode(response.body);
    LoginResponse result = LoginResponse.fromJson(body);
    return result;
  }
}
