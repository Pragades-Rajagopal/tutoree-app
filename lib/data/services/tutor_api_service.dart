import 'package:tutoree_app/config/dotenv_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tutoree_app/config/constants.dart';
import 'package:tutoree_app/data/models/tutor_model.dart';

class TutorApi {
  Future<StudentList> getStudentListForTutor(int tutorId, String token) async {
    final env = await accessENV(assetsFileName: '.env');
    apiHeader["Authorization"] = 'Bearer $token';
    var response = await http.get(
      Uri.parse('${env["URL"]}${endpoints["studentListForTutor"]}/$tutorId'),
      headers: apiHeader,
    );
    var body = jsonDecode(response.body);
    var data = body["data"]["studentList"];
    StudentList result = StudentList.fromJson(data);
    return result;
  }

  Future<TutorProfile> getTutorProfile(int tutorId, String token) async {
    final env = await accessENV(assetsFileName: '.env');
    apiHeader["Authorization"] = 'Bearer $token';
    var response = await http.get(
      Uri.parse('${env["URL"]}${endpoints["tutorProfile"]}/$tutorId'),
      headers: apiHeader,
    );
    var body = jsonDecode(response.body);
    var data = body["data"];
    TutorProfile result = TutorProfile.fromJson(data);
    return result;
  }

  Future<PostTutorProfiletRes> addProfile(
      Map<String, dynamic> request, String token) async {
    final env = await accessENV(assetsFileName: '.env');
    apiHeader["Authorization"] = 'Bearer $token';
    var response = await http.post(
      Uri.parse('${env["URL"]}${endpoints["addTutorProfile"]}'),
      body: json.encode(request),
      headers: apiHeader,
    );
    var body = jsonDecode(response.body);
    PostTutorProfiletRes result = PostTutorProfiletRes.fromJson(body);
    return result;
  }

  Future<HideStudentReqResponse> hideRequest(
      Map<String, dynamic> request, String token) async {
    final env = await accessENV(assetsFileName: '.env');
    apiHeader["Authorization"] = 'Bearer $token';
    var response = await http.post(
      Uri.parse('${env["URL"]}${endpoints["tutorHideStudentReq"]}'),
      body: json.encode(request),
      headers: apiHeader,
    );
    var body = jsonDecode(response.body);
    HideStudentReqResponse result = HideStudentReqResponse.fromJson(body);
    return result;
  }
}
