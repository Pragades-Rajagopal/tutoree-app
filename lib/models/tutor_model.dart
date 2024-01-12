class TutorProfile {
  int? tutorId;
  String? name;
  String? email;
  int? mobileNum;
  String? type;
  String? bio;
  String? websites;
  int? mailSubscription;
  List interests = [];
  List feeds = [];

  TutorProfile({
    this.tutorId,
    this.name,
    this.email,
    this.mobileNum,
    this.type,
    this.bio,
    this.websites,
    this.mailSubscription,
  });

  TutorProfile.fromJson(Map<String, dynamic> json) {
    tutorId = json["student_id"];
    name = json["name"];
    email = json["email"];
    mobileNum = json["mobile_number"];
    type = json["type"];
    bio = json["bio"];
    websites = json["websites"];
    mailSubscription = json["mailSubscription"];
    interests.addAll(json["interests"]);
    feeds.addAll(json["feeds"]);
  }
}
