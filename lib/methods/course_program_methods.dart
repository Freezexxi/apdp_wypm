import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wypm_apdp/classes/course_program.dart';

class CourseProgramMethods {
  // Add a new course program to Firestore
  Future<bool> addCourseProgram(CourseProgram program) async {
    bool status = false;
    try {
      await FirebaseFirestore.instance
          .collection("coursePrograms")
          .doc(program.programId)
          .set(program.toMap());

      status = true;
    } catch (e) {
      print(e);

    }
    return status;
  }

  // Retrieve all course programs from Firestore
  Future<List<CourseProgram>> fetchAllCoursePrograms() async {
    try {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection("coursePrograms").get();

      List<CourseProgram> programs = snapshot.docs.map((doc) {
        return CourseProgram.fromSnapshot(doc.data() as Map<String, dynamic>);
      }).toList();

      return programs;
    } catch (e) {
      return [];
    }
  }

  // Retrieve a course program by its ID
  Future<CourseProgram?> findCourseProgramById(String programId) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection("coursePrograms")
          .where('programId', isEqualTo: programId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return CourseProgram.fromSnapshot(snapshot.docs.first.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Update a course program in Firestore
  Future<bool> updateCourseProgram(CourseProgram program) async {
    bool result = false;
    try {
      await FirebaseFirestore.instance
          .collection("coursePrograms")
          .doc(program.programId)
          .set(program.toMap());
      result = true;
    } catch (e) {
      result = false;
    }
    return result;
  }

  // Remove a course program from Firestore
  Future<bool> removeCourseProgram(String programId) async {
    bool isSuccess = false;
    try {
      await FirebaseFirestore.instance
          .collection("coursePrograms")
          .doc(programId)
          .delete();
      isSuccess = true;
    } catch (e) {
      isSuccess = false;
    }
    return isSuccess;
  }

  // Get the total number of course programs
  Future<int> getTotalCourseProgramCount() async {
    int programCount = -1;
    try {
      var data = await FirebaseFirestore.instance.collection("coursePrograms").count().get();
      programCount = data.count ?? 0;
    } catch (e) {
      programCount = -1;
    }
    return programCount;
  }
}
