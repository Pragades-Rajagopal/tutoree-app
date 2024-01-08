/// Model to get the global feeds
class FeedsListResponse {
  List<Map<String, dynamic>> data = [];

  FeedsListResponse.fromJson(List<dynamic> json) {
    for (var i = 0; i < json.length; i++) {
      data.add({
        "id": json[i]["id"],
        "content": json[i]["content"],
        "createdBy": json[i]["created_by"],
        "createdOn": json[i]["created_on"],
        "date": json[i]["date_"]
      });
    }
  }
}

class AddFeedResponse {
  int? statusCode;
  String? message;

  AddFeedResponse({
    this.statusCode,
    this.message,
  });

  AddFeedResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json["statusCode"];
    message = json["message"];
  }
}
