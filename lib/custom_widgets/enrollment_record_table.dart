import 'package:flutter/material.dart';
import 'package:wypm_apdp/classes/enrollment_record.dart';
import 'package:wypm_apdp/methods/enroll_record_methods.dart';

class EnrollmentRecordTable extends StatefulWidget {
  final String learnerId;

  EnrollmentRecordTable({required this.learnerId});

  @override
  _EnrollmentRecordTableState createState() => _EnrollmentRecordTableState();
}

class _EnrollmentRecordTableState extends State<EnrollmentRecordTable> {
  List<EnrollmentRecord> enrollments = [];
  bool isLoading = true;
  EnrollRecordMethods _enrollRecordMethods = EnrollRecordMethods();

  @override
  void initState() {
    super.initState();
    _fetchEnrollments();
  }

  Future<void> _fetchEnrollments() async {
    try {
      List<EnrollmentRecord> fetchedEnrollments = await _enrollRecordMethods.fetchEnrollmentsByLearner(widget.learnerId);
      setState(() {
        enrollments = fetchedEnrollments;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching enrollments: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : enrollments.isEmpty
        ? Text("No enrollments found")
        : DataTable(
      columns: const [
        DataColumn(label: Text('Course Name')),
        DataColumn(label: Text('Discount')),
        DataColumn(label: Text('Final Cost')),
        DataColumn(label: Text('Enrollment Date')),
      ],
      rows: enrollments.map((enrollment) {
        return DataRow(cells: [
          DataCell(Text(enrollment.programTitle)),
          DataCell(Text('${enrollment.discountRate}%')),
          DataCell(Text('\$${enrollment.finalCost.toStringAsFixed(2)}')),
          DataCell(Text('${enrollment.enrollmentDate.toLocal().toString().split(' ')[0]}')),
        ]);
      }).toList(),
    );
  }
}
