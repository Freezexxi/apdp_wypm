import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:wypm_apdp/main.dart'; // Update with your app's main entry point
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Student List Page displays enrolled students and filters them',
      (WidgetTester tester) async {
    // Start the app
    await tester.pumpWidget(App()); // Replace with your main widget

    // Navigate to the Student List Page
    // Assuming your app has a button or navigation method to access this page
    // Add navigation steps here if necessary.

    // Wait for the page to load the students
    await tester.pumpAndSettle(); // Ensures that all async tasks are complete

    // Verify that a loading indicator is displayed initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Mock Firestore data for learners
    final List<Map<String, dynamic>> mockLearners = [
      {
        'learnerId': '1',
        'fullName': 'John Doe',
        'emailAddress': 'john@example.com',
        'group': 'A',
        'genderIdentity': 'Male',
        'joinedDate': Timestamp.now(),
        'homeAddress': '123 Street',
        'enrolledCourses': ['Math', 'Science'],
      },
      {
        'learnerId': '2',
        'fullName': 'Jane Smith',
        'emailAddress': 'jane@example.com',
        'group': 'B',
        'genderIdentity': 'Female',
        'joinedDate': Timestamp.now(),
        'homeAddress': '456 Avenue',
        'enrolledCourses': ['English', 'History'],
      }
    ];

    // Simulate the students being fetched from Firestore and displayed
    await FirebaseFirestore.instance
        .collection('learners')
        .add(mockLearners[0]);
    await FirebaseFirestore.instance
        .collection('learners')
        .add(mockLearners[1]);

    // Rebuild the widget tree after data is added
    await tester.pumpAndSettle();

    // Verify that the students are displayed in the list
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Jane Smith'), findsOneWidget);

    // Search for a student by name
    await tester.enterText(find.byType(TextField), 'John');
    await tester.pumpAndSettle();

    // Verify that only 'John Doe' is displayed after filtering
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Jane Smith'), findsNothing);

    // Test deleting a student
    await tester.tap(find.widgetWithIcon(IconButton, Icons.delete).first);
    await tester.pumpAndSettle();

    // Verify that the student has been deleted and no longer appears in the list
    expect(find.text('John Doe'), findsNothing);

    // Verify the remaining student is still in the list
    expect(find.text('Jane Smith'), findsOneWidget);
  });
}
