/// Model to get the list of tutors
/// based on student's interest
class TutorList {
  // int? tutorId;
  // String? tutorName;
  // String? bio;
  // String? websites;
  // String? courses;
  // int? studentId;
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
      });
    }
  }
}
