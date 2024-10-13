import 'package:cloud_firestore/cloud_firestore.dart';

class Enrollment {
  final String _enrollmentId;
  DateTime enrolledTime;
  num discountPercent;
  double totalCost;
  String studentUniqueId;
  String courseName;

  // Constructor with all required fields
  Enrollment(this._enrollmentId,{
    required this.enrolledTime,
    required this.discountPercent,
    required this.totalCost,
    required this.studentUniqueId,
    required this.courseName
  });

  // Getter for private enrollId
  String get enrollmentId => _enrollmentId;

  // Convert object to a Map (for Firestore)
  Map<String, dynamic> toJSON() {
    return {
      'enrollmentId': _enrollmentId,
      'enrolledTime': enrolledTime,
      'discountPercent': discountPercent,
      'totalCost': totalCost,
      'studentUniqueId': studentUniqueId,
      'courseName': courseName
    };
  }

  // Method to create an Enrollment object from Firestore data
  static Enrollment fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final Timestamp timestamp = data['enrolledTime'] as Timestamp;
    final DateTime enrolledDateTime = timestamp.toDate();

    return Enrollment(
      data['enrollmentId'],
      enrolledTime: enrolledDateTime,
      discountPercent: data['discountPercent'],
      totalCost: data['totalCost'],
      studentUniqueId: data['studentUniqueId'],
      courseName: data['courseName']
    );
  }
}
