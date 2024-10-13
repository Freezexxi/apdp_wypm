import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mhk_star_education/objects/course.dart';
import 'package:mhk_star_education/objects/enrollment.dart';
import 'package:mhk_star_education/objects/methods/enroll_methods.dart';
import 'package:mhk_star_education/static_data.dart';

import '../student.dart';

class StudentMethods {
  // Method to create (register) a student in Firestore
  Future<String> register(Student student) async {
    String sId = '';
    try {
      await FirebaseFirestore.instance
          .collection("students")
          .doc(student.studentId)
          .set(student.toJSON());

      sId = student.studentId;
    } catch (e) {
      print(e);
      sId = '';
    }

    return sId;
  }

  // Method to read (get) all students from Firestore
  Future<List<Student>> get() async {
    try {
      // Fetch all student documents
      QuerySnapshot data =
          await FirebaseFirestore.instance.collection("students").get();

      // Map over the documents to create Student objects
      List<Student> students = data.docs.map((doc) {
        return Student.fromDoc(doc);
      }).toList();

      return students;
    } catch (e) {
      return [];
    }
  }

  // Method to read a student by Id
  Future<Student?> getStudentById(String studentId) async {
    try {
      var data = await FirebaseFirestore.instance
          .collection("students")
          .where('studentId', isEqualTo: studentId)
          .get();

      if (data.docs.isNotEmpty) {
        return Student.fromDoc(data.docs.first);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Method to update a student in Firestore
  Future<bool> updateStudent(Student student) async {
    bool status = false;

    try {
      await FirebaseFirestore.instance
          .collection("students")
          .doc(student.studentId)
          .update(student.toJSON());
      status = true;
    } catch (e) {
      status = false;
    }

    return status;
  }

  // Method to delete a student from Firestore
  Future<bool> deleteStudent(String studentId) async {
    bool status = false;

    try {
      await FirebaseFirestore.instance
          .collection("students")
          .doc(studentId)
          .delete();
      status = true;
    } catch (e) {
      status = false;
    }

    return status;
  }

  Future<bool> enrollCourses(Student student, List<Course> courses) async {
    bool status = false;
    bool allEnrollmentsSuccessful = true;

    try {
      final DateTime enrolledTime = DateTime.now();
      Student dStudent = Student.studentFactory(
          student.studentId,
          student.name,
          student.email,
          student.phone,
          student.address,
          student.registerDate,
          student.gender,
          student.section,
          student.courses);

      // Loop through each course and enroll the student
      for (Course course in courses) {
        if (!dStudent.courses.contains(course)) {
          double discountAmount =
              (course.courseFee * dStudent.discount()) / 100;
          double totalFee = course.courseFee - discountAmount;
          var newEnrollmentId = uuid.v1();
          // Create a new enrollment
          Enrollment newEnrollment = Enrollment(newEnrollmentId,
              enrolledTime: enrolledTime,
              discountPercent: dStudent.discount(),
              totalCost: totalFee,
              studentUniqueId: student.studentId,
              courseName: course.name);

          EnrollMethods enrollMethods = EnrollMethods();
          // Attempt to enroll the student in the course
          bool status = await enrollMethods.enroll(newEnrollment);
          if (!status) {
            allEnrollmentsSuccessful = false;
          }
        }
      }

      // Update the student's number of courses and save the updated student
      for (Course course in courses) {
        if (!student.courses.contains(course)) {
          student.courses.add(course);
        }
      }
      updateStudent(student);

      // Set the response based on whether all enrollments were successful
      status = allEnrollmentsSuccessful;
    } catch (e) {
      status = false;
    }

    return status;
  }

  // Method to get the total number of students
  Future<int> getTotalStudentNumber() async {
    int totalStudent = -1;

    try {
      var data =
          await FirebaseFirestore.instance.collection("students").count().get();

      totalStudent = data.count ?? 0;
    } catch (e) {
      totalStudent = -1;
    }

    return totalStudent;
  }
}
