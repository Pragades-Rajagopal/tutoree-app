/// Model to get the list of students
/// for a tutor
class StudentList {
  List<Map<String, dynamic>> data = [];

  StudentList.fromJson(List<dynamic> json) {
    for (var i = 0; i < json.length; i++) {
      data.add({
        "tutorId": json[i]["tutor_id"],
        "studentName": json[i]["name"],
        "email": json[i]["email"],
        "mobile_no": json[i]["mobile_no"],
        "interests": json[i]["interests"],
        "studentId": json[i]["student_id"],
      });
    }
  }
}

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
