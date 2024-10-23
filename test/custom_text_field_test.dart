import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wypm_apdp/custom_widgets/custom_text_field.dart';

void main() {
  testWidgets('CustomTextField displays correctly and accepts input',
      (WidgetTester tester) async {
    // Create controller for TextField
    final TextEditingController controller = TextEditingController();

    // Build CustomTextField widget inside MaterialApp
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomTextField(
            controller: controller,
            placeholder: 'Enter text',
            borderColor: Colors.blue,
            borderRadius: 8.0,
            placeholderColor: Colors.grey,
            backgroundColor: Colors.white,
            isFilled: true,
            textStyle: TextStyle(color: Colors.black),
            minLines: 1,
            maxLines: 1,
          ),
        ),
      ),
    );

    // Verify if placeholder text is present
    expect(find.text('Enter text'), findsOneWidget);

    // Enter text into TextFormField
    await tester.enterText(find.byType(TextFormField), 'Hello Flutter');
    expect(controller.text, 'Hello Flutter');

    // Rebuild widget after text input
    await tester.pump();

    // Verify if entered text is present
    expect(find.text('Hello Flutter'), findsOneWidget);
  });
}
