import 'package:tutoree_app/config/dotenv_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tutoree_app/config/constants.dart';
import 'package:tutoree_app/data/models/feeds_model.dart';

class FeedsApi {
  Future<FeedsListResponse> getGlobalFeeds(
      int limit, int offset, String token) async {
    final env = await accessENV(assetsFileName: '.env');
    apiHeader["Authorization"] = 'Bearer $token';
    var response = await http.get(
      Uri.parse(
          '${env["URL"]}${endpoints["feed"]}?limit=$limit&offset=$offset'),
      headers: apiHeader,
    );
    var body = jsonDecode(response.body);
    var data = body["data"];
    FeedsListResponse result = FeedsListResponse.fromJson(data);
    return result;
  }

  Future<AddFeedResponse> saveFeed(
      Map<String, dynamic> request, String token) async {
    final env = await accessENV(assetsFileName: '.env');
    apiHeader["Authorization"] = 'Bearer $token';
    var response = await http.post(
      Uri.parse('${env["URL"]}${endpoints["feed"]}'),
      body: json.encode(request),
      headers: apiHeader,
    );
    var body = jsonDecode(response.body);
    AddFeedResponse result = AddFeedResponse.fromJson(body);
    return result;
  }

  Future<DeleteFeedResponse> deleteFeed(int id, String token) async {
    final env = await accessENV(assetsFileName: '.env');
    apiHeader["Authorization"] = 'Bearer $token';
    var response = await http.delete(
      Uri.parse('${env["URL"]}${endpoints["feed"]}/$id'),
      headers: apiHeader,
    );
    var body = jsonDecode(response.body);
    DeleteFeedResponse result = DeleteFeedResponse.fromJson(body);
    return result;
  }

  Future<FeedUserData> getFeedUserData(int userId, String token) async {
    final env = await accessENV(assetsFileName: '.env');
    apiHeader["Authorization"] = 'Bearer $token';
    var response = await http.get(
      Uri.parse('${env["URL"]}${endpoints["feeduserData"]}/$userId'),
      headers: apiHeader,
    );
    var body = jsonDecode(response.body);
    var data = body["data"];
    FeedUserData result = FeedUserData.fromJson(data);
    return result;
  }

  Future<UpdateUpvoteResponse> updateUpvote(int id, String token) async {
    final env = await accessENV(assetsFileName: '.env');
    apiHeader["Authorization"] = 'Bearer $token';
    var response = await http.put(
      Uri.parse('${env["URL"]}${endpoints["feed"]}/$id/upvote'),
      headers: apiHeader,
    );
    var body = jsonDecode(response.body);
    UpdateUpvoteResponse result = UpdateUpvoteResponse.fromJson(body);
    return result;
  }
}
