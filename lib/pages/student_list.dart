import 'package:flutter/material.dart';
import 'package:mhk_star_education/objects/methods/student_methods.dart';
import 'package:mhk_star_education/objects/student.dart';
import 'package:mhk_star_education/pages/student_detail_page.dart';
import 'package:mhk_star_education/utils/status_show.dart';

class StudentList extends StatefulWidget {
  const StudentList({super.key});

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  final StudentMethods _studentMethods = StudentMethods();
  List<Student> _students = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    try {
      List<Student> students = await _studentMethods.get();
      setState(() {
        _students = students;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching students: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleDelete(String studentId) async {
    bool status = await _studentMethods.deleteStudent(studentId);
    if (status) {
      setState(() {
        _students.removeWhere((student) => student.studentId == studentId);
      });
      StatusShow(context, "Student deleted!");
    } else {
      StatusShow(context, "Error: Student deletion failed!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                'Student List',
                style: TextStyle(fontSize: 30),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _students.isEmpty
                ? const Center(child: Text('No students found'))
                : Expanded(
              child: ListView.builder(
                itemCount: _students.length,
                itemBuilder: (context, index) {
                  Student student = _students[index];
print(student);
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          // Left: Student name, email, section
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                student.name,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(student.email),
                              Text('Section: ${student.section}'),
                            ],
                          ),
                          // Right: Edit and Delete icons
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          StudentDetailPage(
                                              student: student),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.red),
                                onPressed: () {
                                  _handleDelete(student.studentId);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
