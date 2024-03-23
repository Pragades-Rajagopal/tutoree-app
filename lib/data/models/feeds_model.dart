/// Model to get the global feeds
class FeedsListResponse {
  List<Map<String, dynamic>> data = [];

  FeedsListResponse.fromJson(List<dynamic> json) {
    for (var i = 0; i < json.length; i++) {
      data.add({
        "id": json[i]["id"],
        "content": json[i]["content"],
        "upvotes": json[i]["upvotes"],
        "createdBy": json[i]["created_by"],
        "createdById": json[i]["created_by_id"],
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

class DeleteFeedResponse {
  int? statusCode;
  String? message;

  DeleteFeedResponse({
    this.statusCode,
    this.message,
  });

  DeleteFeedResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json["statusCode"];
    message = json["message"];
  }
}

/// Feed user data model
class FeedUserData {
  int? id;
  String? name;
  String? email;
  String? bio;
  String? websites;
  String? interests;
  String? userType;

  FeedUserData({
    this.id,
    this.name,
    this.email,
    this.bio,
    this.websites,
    this.interests,
    this.userType,
  });

  FeedUserData.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    email = json["email"];
    bio = json["bio"];
    websites = json["websites"];
    interests = json["interests"];
    userType = json["userType"];
  }
}

class UpdateUpvoteResponse {
  int? statusCode;
  String? message;

  UpdateUpvoteResponse({
    this.statusCode,
    this.message,
  });

  UpdateUpvoteResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json["statusCode"];
    message = json["message"];
  }
}
