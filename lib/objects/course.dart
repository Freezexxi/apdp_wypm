class Course {
  String name;
  double courseFee;
  String courseOverview;
  String teacherName;

  // Constructor
  Course({
    required this.name,
    required this.courseFee,
    required this.courseOverview,
    required this.teacherName,
  });

  // Convert Course object to a Map (for Firestore)
  Map<String, dynamic> toJSON() {
    return {
      'name': name,
      'courseFee': courseFee,
      'courseOverview': courseOverview,
      'teacherName': teacherName,
    };
  }

  // Factory method to map Firestore data to Course object
  factory Course.fromDoc(Map<String, dynamic> data) {
    return Course(
      name: data['name'] ?? '',
      courseOverview: data['courseOverview'] ?? '',
      teacherName: data['teacherName'] ?? '',
      courseFee: (data['courseFee']).toDouble(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Course) return false;
    return name == other.name &&
        courseFee == other.courseFee &&
        teacherName == other.teacherName &&
        courseOverview == other.courseOverview;
  }

  @override
  int get hashCode {
    return name.hashCode ^ courseFee.hashCode ^ teacherName.hashCode ^ courseOverview.hashCode;
  }
}
