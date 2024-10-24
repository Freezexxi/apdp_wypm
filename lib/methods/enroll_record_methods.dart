import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wypm_apdp/classes/enrollment_record.dart';

class EnrollRecordMethods {
  // Retrieve all enrollment records for a specific student from Firestore
  Future<List<EnrollmentRecord>> fetchEnrollmentsByLearner(
      String learnerId) async {
    List<EnrollmentRecord> studentEnrollments = [];
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('enrollments')
          .where('learnerId', isEqualTo: learnerId)
          .get();
      studentEnrollments = snapshot.docs
          .map((doc) => EnrollmentRecord.fromFirestoreDocument(doc))
          .toList();
    } catch (e) {
      print("Error retrieving enrollments for student $learnerId: $e");
      studentEnrollments = [];
    }
    return studentEnrollments;
  }

  // Register a new enrollment record in Firestore
  Future<bool> registerEnrollment(EnrollmentRecord enrollment) async {
    bool isSuccess = false;
    try {
      await FirebaseFirestore.instance
          .collection('enrollments')
          .doc(enrollment.recordId)
          .set(enrollment.toFirestoreMap());
      isSuccess = true;
    } catch (e) {
      print("Error registering enrollment: $e");
      isSuccess = false;
    }
    return isSuccess;
  }

  // Fetch all enrollment records from Firestore
  Future<List<EnrollmentRecord>> fetchAllEnrollments() async {
    List<EnrollmentRecord> enrollments = [];
    try {
      var snapshot =
          await FirebaseFirestore.instance.collection('enrollments').get();
      enrollments = snapshot.docs
          .map((doc) => EnrollmentRecord.fromFirestoreDocument(doc))
          .toList();
    } catch (e) {
      enrollments = [];
    }
    return enrollments;
  }

  // Retrieve a specific enrollment by its ID
  Future<EnrollmentRecord?> fetchEnrollmentById(String enrollmentId) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('enrollments')
          .where('enrollmentId', isEqualTo: enrollmentId)
          .get();
      if (snapshot.docs.isNotEmpty) {
        return EnrollmentRecord.fromFirestoreDocument(snapshot.docs.first);
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching enrollment by ID: $e");
      return null;
    }
  }
}
