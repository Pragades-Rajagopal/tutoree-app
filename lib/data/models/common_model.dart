/// Course model which maps data from API
class Course {
  int id;
  String name;

  Course({
    required this.id,
    required this.name,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json["id"],
      name: json["name"],
    );
  }
}
