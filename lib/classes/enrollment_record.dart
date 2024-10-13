import 'package:cloud_firestore/cloud_firestore.dart';

class EnrollmentRecord {
  final String _recordId;
  DateTime enrollmentDate;
  num discountRate;
  double finalCost;
  String learnerId;
  String learnerName;
  String programId;
  String programTitle;

  // Constructor with all required fields
  EnrollmentRecord(this._recordId,
      {required this.enrollmentDate,
        required this.discountRate,
        required this.finalCost,
        required this.learnerId,
        required this.learnerName,
        required this.programId,
        required this.programTitle});

  // Getter for private recordId
  String get recordId => _recordId;

  // Convert object to a Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'recordId': _recordId,
      'enrollmentDate': enrollmentDate,
      'discountRate': discountRate,
      'finalCost': finalCost,
      'learnerId': learnerId,
      'learnerName': learnerName,
      'programId': programId,
      'programTitle': programTitle,
    };
  }

  // Method to create an EnrollmentRecord object from Firestore data
  static EnrollmentRecord fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final Timestamp timestamp = data['enrollmentDate'] as Timestamp;
    final DateTime convertedDate = timestamp.toDate();

    return EnrollmentRecord(data['recordId'],
        enrollmentDate: convertedDate,
        discountRate: data['discountRate'],
        finalCost: data['finalCost'],
        learnerId: data['learnerId'],
        learnerName: data['learnerName'],
        programId: data['programId'],
        programTitle: data['programTitle']);
  }
}
