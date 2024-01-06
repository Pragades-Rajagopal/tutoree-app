import 'package:tutoree_app/config/dotenv_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tutoree_app/config/constants.dart';
import 'package:tutoree_app/models/student_model.dart';

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
}
