import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wypm_apdp/classes/learner.dart';

void main() {
  group('Learner Discount Tests', () {
    late Learner newLearner;
    late Learner seniorLearner;
    late Learner eliteLearner;

    setUp(() {
      // Creating sample learners with different enrollment counts
      newLearner = NewLearner(
        'learner1',
        fullName: 'John Doe',
        emailAddress: 'john@example.com',
        contactNumber: '123456789',
        joinedDate: Timestamp.now(),
        group: 'A',
        homeAddress: '123 Main St',
        genderIdentity: 'Male',
        enrolledCourses: ['course1'],
      );

      seniorLearner = SeniorLearner(
        'learner2',
        fullName: 'Jane Smith',
        emailAddress: 'jane@example.com',
        contactNumber: '987654321',
        joinedDate: Timestamp.now(),
        group: 'B',
        homeAddress: '456 Elm St',
        genderIdentity: 'Female',
        enrolledCourses: ['course1', 'course2'],
      );

      eliteLearner = EliteLearner(
        'learner3',
        fullName: 'Bob Johnson',
        emailAddress: 'bob@example.com',
        contactNumber: '555555555',
        joinedDate: Timestamp.now(),
        group: 'C',
        homeAddress: '789 Oak St',
        genderIdentity: 'Non-binary',
        enrolledCourses: ['course1', 'course2', 'course3'],
      );
    });

    test('New Learner gets 5% discount', () {
      expect(newLearner.getDiscount(), 5);
    });

    test('Senior Learner gets 10% discount', () {
      expect(seniorLearner.getDiscount(), 10);
    });

    test('Elite Learner gets 20% discount', () {
      expect(eliteLearner.getDiscount(), 20);
    });

    test('Learner with no courses gets 0% discount', () {
      Learner noCourseLearner = Learner(
        'learner4',
        fullName: 'Alice Williams',
        emailAddress: 'alice@example.com',
        contactNumber: '666666666',
        joinedDate: Timestamp.now(),
        group: 'D',
        homeAddress: '111 Maple St',
        genderIdentity: 'Female',
        enrolledCourses: [],
      );
      expect(noCourseLearner.getDiscount(), 0);
    });
  });
}
