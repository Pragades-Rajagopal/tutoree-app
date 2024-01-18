import 'package:tutoree_app/config/dotenv_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tutoree_app/config/constants.dart';
import 'package:tutoree_app/data/models/student_model.dart';

class StudentApi {
  Future<TutorList> getTutorlist(int studentId) async {
    final env = await accessENV(assetsFileName: '.env');
    var response = await http.get(
        Uri.parse('${env["URL"]}${endpoints["studentTutorList"]}/$studentId'));
    var body = jsonDecode(response.body);
    var data = body["data"]["tutorLists"];
    TutorList result = TutorList.fromJson(data);
    return result;
  }

  Future<TutorRequestResponse> sendTutorRequest(
      Map<String, dynamic> request) async {
    final env = await accessENV(assetsFileName: '.env');
    var response = await http.post(
      Uri.parse('${env["URL"]}${endpoints["sendTutorRequest"]}'),
      body: json.encode(request),
      headers: apiHeader,
    );
    var body = jsonDecode(response.body);
    TutorRequestResponse result = TutorRequestResponse.fromJson(body);
    return result;
  }

  Future<StudentProfile> getStudentProfile(int studentId) async {
    final env = await accessENV(assetsFileName: '.env');
    var response = await http.get(
        Uri.parse('${env["URL"]}${endpoints["studentProfile"]}/$studentId'));
    var body = jsonDecode(response.body);
    var data = body["data"];
    StudentProfile result = StudentProfile.fromJson(data);
    return result;
  }

  Future<PostStudentInterestRes> addInterests(
      Map<String, dynamic> request) async {
    final env = await accessENV(assetsFileName: '.env');
    var response = await http.post(
      Uri.parse('${env["URL"]}${endpoints["addStudentInterest"]}'),
      body: json.encode(request),
      headers: apiHeader,
    );
    var body = jsonDecode(response.body);
    PostStudentInterestRes result = PostStudentInterestRes.fromJson(body);
    return result;
  }
}
