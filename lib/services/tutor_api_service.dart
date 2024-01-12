import 'package:tutoree_app/config/dotenv_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tutoree_app/config/constants.dart';
import 'package:tutoree_app/models/tutor_model.dart';

class TutorApi {
  Future<TutorProfile> getStudentProfile(int tutorId) async {
    final env = await accessENV(assetsFileName: '.env');
    var response = await http
        .get(Uri.parse('${env["URL"]}${endpoints["tutorProfile"]}/$tutorId'));
    var body = jsonDecode(response.body);
    var data = body["data"];
    TutorProfile result = TutorProfile.fromJson(data);
    return result;
  }
}
