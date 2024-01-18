import 'package:tutoree_app/config/dotenv_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tutoree_app/config/constants.dart';
import 'package:tutoree_app/data/models/tutor_model.dart';

class TutorApi {
  Future<StudentList> getStudentListForTutor(int tutorId) async {
    final env = await accessENV(assetsFileName: '.env');
    var response = await http.get(
        Uri.parse('${env["URL"]}${endpoints["studentListForTutor"]}/$tutorId'));
    var body = jsonDecode(response.body);
    var data = body["data"]["studentList"];
    StudentList result = StudentList.fromJson(data);
    return result;
  }

  Future<TutorProfile> getTutorProfile(int tutorId) async {
    final env = await accessENV(assetsFileName: '.env');
    var response = await http
        .get(Uri.parse('${env["URL"]}${endpoints["tutorProfile"]}/$tutorId'));
    var body = jsonDecode(response.body);
    var data = body["data"];
    TutorProfile result = TutorProfile.fromJson(data);
    return result;
  }
}
