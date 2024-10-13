import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mhk_star_education/objects/course.dart';

// Human interface for shared attributes
abstract class Human {
  String get _uniqueId;

  String get name;

  String get email;

  String get phone;

  String get address;

  String get gender;
}

// Student class implementing Human interface
class Student implements Human {
  @override
  final String _uniqueId;
  @override
  String name;
  @override
  String email;
  @override
  String phone;
  Timestamp registerDate;
  String section;
  @override
  String gender;
  @override
  String address;
  List<Course> courses;

  // Constructor
  Student(this._uniqueId,
      {required this.name,
      required this.email,
      required this.phone,
      required this.registerDate,
      required this.section,
      required this.gender,
      required this.address,
      required this.courses});

  String get studentId => _uniqueId;

  // Default discount for base Student class
  int discount() => 0;

  // Convert a Student object to a Map (for Firestore)
  Map<String, dynamic> toJSON() {
    return {
      'studentId': _uniqueId,
      'name': name,
      'email': email,
      'phone': phone,
      'registerDate': registerDate,
      'section': section,
      'gender': gender,
      'address': address,
      'courses': courses.map((course) => course.toJSON()).toList(),
    };
  }

  // Create a Student object from Firestore
  static Student fromDoc(DocumentSnapshot doc) {
    final studentData = doc.data() as Map<String, dynamic>;

    // Extract fields from Firestore document
    final String studentId = studentData['studentId'] as String;
    final String name = studentData['name'] as String;
    final String email = studentData['email'] as String;
    final String phone = studentData['phone'] as String;
    final String address = studentData['address'] as String;
    final String section = studentData['section'] as String;
    final String gender = studentData['gender'] as String;
    final Timestamp registerDate = studentData['registerDate'] as Timestamp;
    final List<Course> courses = (studentData['courses'] as List<dynamic>)
        .map((courseData) => Course.fromDoc(courseData as Map<String, dynamic>))
        .toList();

    return studentFactory(studentId, name, email, phone, address,
        registerDate, section, gender, courses);
  }


  // Factory method to create instances based on the number of enrollments
  static Student studentFactory(
      String studentId,
      String name,
      String email,
      String phone,
      String address,
      Timestamp registerDate,
      String section,
      String gender,
      List<Course> courses) {
    switch (courses.length) {
      case 0:
        return Student(studentId,
            name: name,
            email: email,
            phone: phone,
            registerDate: registerDate,
            section: section,
            gender: gender,
            address: address,
            courses: courses);
      case 1:
        return RegisteredStudent(studentId,
            name: name,
            email: email,
            phone: phone,
            registerDate: registerDate,
            section: section,
            address: address,
            gender: gender,
            courses: courses);
      case 2:
        return OldStudent(studentId,
            name: name,
            email: email,
            phone: phone,
            registerDate: registerDate,
            section: section,
            address: address,
            gender: gender,
            courses: courses);
      default:
        return RoyalStudent(studentId,
            name: name,
            email: email,
            phone: phone,
            registerDate: registerDate,
            section: section,
            address: address,
            gender: gender,
            courses: courses);
    }
  }
}

// Subclass for RegisteredStudent
class RegisteredStudent extends Student {
  RegisteredStudent(super._uniqueId,
      {required super.name,
      required super.email,
      required super.phone,
      required super.registerDate,
      required super.section,
      required super.address,
      required super.gender,
      required super.courses});

  @override
  int discount() => 5; // Registered students get 5% discount
}

// Subclass for OldStudent
class OldStudent extends Student {
  OldStudent(super._uniqueId,
      {required super.name,
      required super.email,
      required super.phone,
      required super.registerDate,
      required super.section,
      required super.address,
      required super.gender,
      required super.courses});

  @override
  int discount() => 10; // Old students get 10% discount
}

// Subclass for RoyalStudent
class RoyalStudent extends Student {
  RoyalStudent(super._uniqueId,
      {required super.name,
      required super.email,
      required super.phone,
      required super.registerDate,
      required super.section,
      required super.address,
      required super.gender,
      required super.courses});

  @override
  int discount() => 20; // Royal students get 20% discount
}
