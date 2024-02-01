import 'package:tutoree_app/config/dotenv_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tutoree_app/config/constants.dart';
import 'package:tutoree_app/data/models/common_model.dart';

class CourseApi {
  Future<List<Course>> getCourseList() async {
    final env = await accessENV(assetsFileName: '.env');
    var response =
        await http.get(Uri.parse('${env["URL"]}${endpoints["course"]}'));
    var body = jsonDecode(response.body);
    List<dynamic> data = body["data"];
    var result = data.map((json) => Course.fromJson(json)).toList();
    return result;
  }
}
