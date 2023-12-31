import 'package:tutoree_app/config/dotenv_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tutoree_app/config/constants.dart';
import 'package:tutoree_app/models/feeds_model.dart';

class FeedsApi {
  Future<FeedsListResponse> getGlobalFeeds() async {
    final env = await accessENV(assetsFileName: '.env');
    var response =
        await http.get(Uri.parse('${env["URL"]}${endpoints["feed"]}'));
    var body = jsonDecode(response.body);
    var data = body["data"];
    FeedsListResponse result = FeedsListResponse.fromJson(data);
    return result;
  }

  Future<AddFeedResponse> saveFeed(Map<String, dynamic> request) async {
    final env = await accessENV(assetsFileName: '.env');
    var response = await http.post(
      Uri.parse('${env["URL"]}${endpoints["feed"]}'),
      body: json.encode(request),
      headers: apiHeader,
    );
    var body = jsonDecode(response.body);
    AddFeedResponse result = AddFeedResponse.fromJson(body);
    return result;
  }
}
