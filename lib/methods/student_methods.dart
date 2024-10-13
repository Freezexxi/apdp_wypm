import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wypm_apdp/classes/student.dart';

class LearnerMethods {
  // Register a new student in Firestore
  Future<String> addLearner(Learner learner) async {
    String learnerId = '';
    try {
      await FirebaseFirestore.instance
          .collection("learners")
          .doc(learner.learnerId)
          .set(learner.toFirestoreMap());

      learnerId = learner.learnerId;
    } catch (e) {
      print(e);
      learnerId = '';
    }
    return learnerId;
  }

  // Retrieve all learners from Firestore
  Future<List<Learner>> fetchAllLearners() async {
    try {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection("learners").get();

      List<Learner> learners = snapshot.docs.map((doc) {
        return Learner.fromFirestoreDocument(doc);
      }).toList();

      return learners;
    } catch (e) {
      return [];
    }
  }

  // Retrieve a learner by their ID
  Future<Learner?> findLearnerById(String learnerId) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection("learners")
          .where('learnerId', isEqualTo: learnerId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return Learner.fromFirestoreDocument(snapshot.docs.first);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Update learner information in Firestore
  Future<bool> updateLearner(Learner learner) async {
    bool result = false;
    try {
      await FirebaseFirestore.instance
          .collection("learners")
          .doc(learner.learnerId)
          .update(learner.toFirestoreMap());
      result = true;
    } catch (e) {
      result = false;
    }
    return result;
  }

  // Remove a learner from Firestore
  Future<bool> removeLearner(String learnerId) async {
    bool isSuccess = false;
    try {
      await FirebaseFirestore.instance
          .collection("learners")
          .doc(learnerId)
          .delete();
      isSuccess = true;
    } catch (e) {
      isSuccess = false;
    }
    return isSuccess;
  }

  // Enroll a learner into multiple courses
  // Future<bool> enrollLearnerInCourses(Learner learner, List<Course> courses) async {
  //   bool enrollmentStatus = false;
  //   bool allCoursesEnrolled = true;
  //
  //   try {
  //     final DateTime enrollmentDate = DateTime.now();
  //     Learner updatedLearner = Learner.learnerFactory(
  //         learner.id,
  //         learner.fullName,
  //         learner.emailAddress,
  //         learner.contactNumber,
  //         learner.homeAddress,
  //         learner.joinedDate,
  //         learner.group,
  //         learner.genderIdentity,
  //         learner.enrolledCourses);
  //
  //     for (CourseProgram course in courses) {
  //       if (!updatedLearner.enrolledCourses.contains(course.programName)) {
  //         double discountedAmount = (course.feeInMMK * updatedLearner.getDiscount()) / 100;
  //         double finalFee = course.feeInMMK - discountedAmount;
  //         String enrollmentId = uuid.v1();
  //
  //         EnrollmentRecord newEnrollment = EnrollmentRecord(
  //             enrollmentId,
  //             enrolledTime: enrollmentDate,
  //             discountPercent: updatedLearner.getDiscount(),
  //             totalCost: finalFee,
  //             learnerId: learner.id,
  //             courseName: course.courseName);
  //
  //         EnrollMethods enrollMethods = EnrollMethods();
  //         bool enrollmentSuccess = await enrollMethods.enroll(newEnrollment);
  //
  //         if (!enrollmentSuccess) {
  //           allCoursesEnrolled = false;
  //         }
  //       }
  //     }
  //
  //     for (Course course in courses) {
  //       if (!learner.enrolledCourses.contains(course.name)) {
  //         learner.enrolledCourses.add(course.name);
  //       }
  //     }
  //
  //     updateLearner(learner);
  //     enrollmentStatus = allCoursesEnrolled;
  //   } catch (e) {
  //     enrollmentStatus = false;
  //   }
  //   return enrollmentStatus;
  // }

  // Get the total number of learners
  Future<int> getTotalLearnerCount() async {
    int learnerCount = -1;
    try {
      var data = await FirebaseFirestore.instance.collection("learners").count().get();
      learnerCount = data.count ?? 0;
    } catch (e) {
      learnerCount = -1;
    }
    return learnerCount;
  }
}
