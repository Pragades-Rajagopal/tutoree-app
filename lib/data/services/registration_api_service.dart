import 'package:tutoree_app/config/dotenv_config.dart';
import 'package:tutoree_app/data/models/registration_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tutoree_app/config/constants.dart';

class RegistrationApi {
  Future<RegistrationResponse> register(Map<String, dynamic> data) async {
    final env = await accessENV(assetsFileName: '.env');
    var response = await http.post(
      Uri.parse('${env["URL"]}${endpoints["user"]}'),
      body: json.encode(data),
      headers: apiHeader,
    );
    var body = jsonDecode(response.body);
    RegistrationResponse result = RegistrationResponse.fromJson(body);
    return result;
  }
}

class OtpApi {
  Future<OTPresponse> register(Map<String, String> data) async {
    final env = await accessENV(assetsFileName: '.env');
    var response = await http.post(
      Uri.parse('${env["URL"]}${endpoints["otp"]}'),
      body: json.encode(data),
      headers: apiHeader,
    );
    var body = jsonDecode(response.body);
    OTPresponse result = OTPresponse.fromJson(body);
    return result;
  }

  Future<ResendOTPResponse> sendOtp(Map<String, String> data) async {
    final env = await accessENV(assetsFileName: '.env');
    var response = await http.post(
      Uri.parse('${env["URL"]}${endpoints["resendOtp"]}'),
      body: json.encode(data),
      headers: apiHeader,
    );
    var body = jsonDecode(response.body);
    ResendOTPResponse result = ResendOTPResponse.fromJson(body);
    return result;
  }
}
