import 'package:flutter/material.dart';
import 'package:wypm_apdp/classes/learner.dart';
import 'package:wypm_apdp/custom_widgets/display_status.dart';
import 'package:wypm_apdp/methods/student_methods.dart';
import 'package:wypm_apdp/pages/learner_edit_page.dart';

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  List<Learner>? students;
  List<Learner>? filteredStudents; // List to store filtered results
  final LearnerMethods _learnerMethods = LearnerMethods();
  final TextEditingController _searchController = TextEditingController();

  Future<void> _fetchStudentList() async {
    List<Learner> learners = await _learnerMethods.fetchAllLearners();
    setState(() {
      students = learners;
      filteredStudents = learners; // Initialize with all learners
    });
  }

  @override
  void initState() {
    _fetchStudentList();
    super.initState();
  }

  // Method to filter the student list based on search query
  void _filterStudents(String query) {
    setState(() {
      filteredStudents = students!
          .where((student) =>
              student.fullName.toLowerCase().contains(query.toLowerCase()) ||
              student.learnerId.contains(query))
          .toList();
    });
  }

  Future<void> _deleteLearner(String id)async{
    bool status = await _learnerMethods.removeLearner(id);
    if(status){
      displayStatus(context, "Delete Successful");
    }else{
      displayStatus(context, "Delete Fail!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student List'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // Adds padding around the content
          child: SelectionArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Registered Students', // Title
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                // Search bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search by name or ID',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onChanged: (value) {
                    _filterStudents(value);
                  },
                ),
                const SizedBox(height: 20.0),
                students == null
                    ? const Center(child: CircularProgressIndicator())
                    : filteredStudents!.isEmpty
                        ? const Center(
                            child: Text(
                              'No students found.',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: filteredStudents!.length,
                              itemBuilder: (context, index) {
                                final student = filteredStudents![index];
                                return Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  elevation: 2.0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              student.fullName,
                                              style: const TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4.0),
                                            Text('ID: ${student.learnerId}'),
                                            const SizedBox(height: 4.0),
                                            Text('Section: ${student.group}'),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit,
                                                  color: Colors.blue),
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        LearnerEditPage(
                                                            learner: student),
                                                  ),
                                                );
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.red),
                                              onPressed: () {
                                                _deleteLearner(student.learnerId);
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
        ),
      ),
    );
  }
}
