import 'package:cloud_firestore/cloud_firestore.dart';

// Individual interface with common attributes
abstract class Individual {
  String get id;

  String get fullName;

  String get genderIdentity;
}

// Learner class implementing Individual interface
class Learner implements Individual {
  @override
  final String id;
  @override
  String fullName;
  String emailAddress;
  String contactNumber;
  Timestamp joinedDate;
  String group;
  @override
  String genderIdentity;
  String homeAddress;
  List<String> enrolledCourses;

  // Constructor
  Learner(this.id,
      {required this.fullName,
        required this.emailAddress,
        required this.contactNumber,
        required this.joinedDate,
        required this.group,
        required this.genderIdentity,
        required this.homeAddress,
        required this.enrolledCourses});

  String get learnerId => id;

  // Default fee reduction for base Learner class
  int getDiscount() => 0;

  // Convert a Learner object to a Map (for Firestore)
  Map<String, dynamic> toFirestoreMap() {
    return {
      'learnerId': id,
      'fullName': fullName,
      'emailAddress': emailAddress,
      'contactNumber': contactNumber,
      'joinedDate': joinedDate,
      'group': group,
      'genderIdentity': genderIdentity,
      'homeAddress': homeAddress,
      'enrolledCourses': enrolledCourses,
    };
  }

  // Create a Learner object from Firestore document
  static Learner fromFirestoreDocument(DocumentSnapshot doc) {
    final learnerData = doc.data() as Map<String, dynamic>;

    // Extract fields from Firestore document
    final String learnerId = learnerData['learnerId'] as String;
    final String fullName = learnerData['fullName'] as String;
    final String emailAddress = learnerData['emailAddress'] as String;
    final String contactNumber = learnerData['contactNumber'] as String;
    final String homeAddress = learnerData['homeAddress'] as String;
    final String group = learnerData['group'] as String;
    final String genderIdentity = learnerData['genderIdentity'] as String;
    final Timestamp joinedDate = learnerData['joinedDate'] as Timestamp;

    // Convert dynamic list to List<String>
    final List<dynamic> enrolledCoursesDynamic = learnerData['enrolledCourses'] as List<dynamic>;
    final List<String> enrolledCourses = enrolledCoursesDynamic.cast<String>();

    return learnerFactory(
      learnerId,
      fullName,
      emailAddress,
      contactNumber,
      homeAddress,
      joinedDate,
      group,
      genderIdentity,
      enrolledCourses,
    );
  }

  // Factory method to create instances based on number of enrollments
  static Learner learnerFactory(
      String learnerId,
      String fullName,
      String emailAddress,
      String contactNumber,
      String homeAddress,
      Timestamp joinedDate,
      String group,
      String genderIdentity,
      List<String> enrolledCourses) {
    if (enrolledCourses.isEmpty) {
      return Learner(learnerId,
          fullName: fullName,
          emailAddress: emailAddress,
          contactNumber: contactNumber,
          joinedDate: joinedDate,
          group: group,
          genderIdentity: genderIdentity,
          homeAddress: homeAddress,
          enrolledCourses: enrolledCourses);
    } else if (enrolledCourses.length == 1) {
      return NewLearner(learnerId,
          fullName: fullName,
          emailAddress: emailAddress,
          contactNumber: contactNumber,
          joinedDate: joinedDate,
          group: group,
          homeAddress: homeAddress,
          genderIdentity: genderIdentity,
          enrolledCourses: enrolledCourses);
    } else if (enrolledCourses.length == 2) {
      return SeniorLearner(learnerId,
          fullName: fullName,
          emailAddress: emailAddress,
          contactNumber: contactNumber,
          joinedDate: joinedDate,
          group: group,
          homeAddress: homeAddress,
          genderIdentity: genderIdentity,
          enrolledCourses: enrolledCourses);
    } else {
      return EliteLearner(learnerId,
          fullName: fullName,
          emailAddress: emailAddress,
          contactNumber: contactNumber,
          joinedDate: joinedDate,
          group: group,
          homeAddress: homeAddress,
          genderIdentity: genderIdentity,
          enrolledCourses: enrolledCourses);
    }
  }
}

// Subclass for NewLearner
class NewLearner extends Learner {
  NewLearner(super.id,
      {required super.fullName,
        required super.emailAddress,
        required super.contactNumber,
        required super.joinedDate,
        required super.group,
        required super.homeAddress,
        required super.genderIdentity,
        required super.enrolledCourses});

  @override
  int getDiscount() => 5; // New learners get 5% discount
}

// Subclass for SeniorLearner
class SeniorLearner extends Learner {
  SeniorLearner(super.id,
      {required super.fullName,
        required super.emailAddress,
        required super.contactNumber,
        required super.joinedDate,
        required super.group,
        required super.homeAddress,
        required super.genderIdentity,
        required super.enrolledCourses});

  @override
  int getDiscount() => 10; // Senior learners get 10% discount
}

// Subclass for EliteLearner
class EliteLearner extends Learner {
  EliteLearner(super.id,
      {required super.fullName,
        required super.emailAddress,
        required super.contactNumber,
        required super.joinedDate,
        required super.group,
        required super.homeAddress,
        required super.genderIdentity,
        required super.enrolledCourses});

  @override
  int getDiscount() => 20; // Elite learners get 20% discount
}
