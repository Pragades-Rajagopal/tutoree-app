/// Model to get the list of tutors
/// based on student's interest
class TutorList {
  List<Map<String, dynamic>> data = [];

  TutorList.fromJson(List<dynamic> json) {
    for (var i = 0; i < json.length; i++) {
      data.add({
        "tutorId": json[i]["tutor_id"],
        "tutorName": json[i]["tutor_name"],
        "bio": json[i]["bio"],
        "websites": json[i]["websites"],
        "courses": json[i]["courses"],
        "studentId": json[i]["student_id"],
        "tutorReqStatus": json[i]["tutor_req_status"],
      });
    }
  }
}

/// Request model to send request to tutor
class TutorRequest {
  int? studentId;
  int? tutorId;

  TutorRequest({
    this.studentId,
    this.tutorId,
  });
}

/// Response model to send request to tutor
class TutorRequestResponse {
  int? statusCode;
  String? message;

  TutorRequestResponse({
    this.statusCode,
    this.message,
  });

  TutorRequestResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json["statusCode"];
    message = json["message"];
  }
}

class StudentProfile {
  int? studentId;
  String? name;
  String? email;
  int? mobileNum;
  String? type;
  List interests = [];
  List feeds = [];

  StudentProfile({
    this.studentId,
    this.name,
    this.email,
    this.mobileNum,
    this.type,
  });

  StudentProfile.fromJson(Map<String, dynamic> json) {
    studentId = json["student_id"];
    name = json["name"];
    email = json["email"];
    mobileNum = json["mobile_number"];
    type = json["type"];
    interests.addAll(json["interests"]);
    feeds.addAll(json["feeds"]);
  }
}

class PostStudentInterestReq {
  int? studentId;
  List<int>? courseIds;

  PostStudentInterestReq({
    this.studentId,
    this.courseIds,
  });
}

/// Response model to add student interests
class PostStudentInterestRes {
  int? statusCode;
  String? message;

  PostStudentInterestRes({
    this.statusCode,
    this.message,
  });

  PostStudentInterestRes.fromJson(Map<String, dynamic> json) {
    statusCode = json["statusCode"];
    message = json["message"];
  }
}
