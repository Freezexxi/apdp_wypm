import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mhk_star_education/objects/enrollment.dart';

class EnrollMethods {
  Future<int> getTotal() async {
    int totalEnrollments = -1;

    try {
      var data = await FirebaseFirestore.instance
          .collection('enrollments')
          .count()
          .get();

      totalEnrollments = data.count ?? 0;
    } catch (error) {
      totalEnrollments = -1;
    }

    return totalEnrollments;
  }

  // Create (Register) an enrollment in Firestore
  Future<bool> enroll(Enrollment enrollment) async {
    bool status = false;

    try {
      await FirebaseFirestore.instance
          .collection('enrollments')
          .doc(enrollment.enrollmentId)
          .set(enrollment.toJSON());
      status = true;
    } catch (error) {
      print("Error creating enrollment: $error");
      status = false;
    }

    return status;
  }

  // Read (Get) enrollments from Firestore
  Future<List<Enrollment>> get() async {
    List<Enrollment> list = [];

    try {
      var data =
          await FirebaseFirestore.instance.collection('enrollments').get();
      for (var doc in data.docs) {
        Enrollment x = Enrollment.fromDoc(doc);
        list.add(x);
      }
    } catch (error) {
      list = [];
    }

    return list;
  }

  // Read enrollment by Id
  Future<Enrollment?> readEnrollmentById(String enId) async {
    try {
      var data = await FirebaseFirestore.instance
          .collection('enrollments')
          .where('enId', isEqualTo: enId)
          .get();

      if (data.docs.isNotEmpty) {
        return Enrollment.fromDoc(data.docs.first);
      } else {
        return null;
      }
    } catch (error) {
      print("Error reading enrollment by id: $error");
      return null;
    }
  }

  Future<List<Enrollment>> getEnrollmentByStudent(String studentId) async {
    try {
      // Fetch all enrollment documents for the specific student
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('enrollments')
          .where('studentId', isEqualTo: studentId)
          .get();

      // Map over the documents to create Enrollment objects
      List<Enrollment> enrollments = snapshot.docs.map((doc) {
        return Enrollment.fromDoc(doc);
      }).toList();

      return enrollments;
    } catch (error) {
      print("Error fetching enrollments for student $studentId: $error");
      return [];
    }
  }
}
