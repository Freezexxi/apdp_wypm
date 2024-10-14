import 'package:flutter/material.dart';
import 'package:wypm_apdp/classes/learner.dart';
import 'package:wypm_apdp/custom_widgets/display_status.dart';
import 'package:wypm_apdp/methods/course_program_methods.dart';
import 'package:wypm_apdp/methods/student_methods.dart';

import 'learner_edit_page.dart'; // Make sure to import the edit page

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int totalStudents = -1;
  int totalCourses = -1;
  String searchQuery = '';
  LearnerMethods _learnerMethods = LearnerMethods();
  CourseProgramMethods _courseProgramMethods = CourseProgramMethods();
  List<Learner> _learners = [];

  @override
  void initState() {
    super.initState();
    _fetchCounts();
  }

  Future<void> _fetchCounts() async {
    totalStudents = await _learnerMethods.getTotalLearnerCount();
    totalCourses = await _courseProgramMethods.getTotalCourseProgramCount();
    _learners = await _learnerMethods.fetchAllLearners();

    setState(() {});
  }

  Future<void> _deleteLearner(String id) async {
    bool status = await _learnerMethods.removeLearner(id);
    if (status) {
      displayStatus(context, "Delete Successful");
    } else {
      displayStatus(context, "Delete Fail!");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter learners based on the search query
    List<Learner> filteredLearners = _learners.where((learner) {
      return searchQuery.isEmpty ||
          learner.fullName.toLowerCase().contains(searchQuery.toLowerCase()) ||
          learner.learnerId.toString().contains(
              searchQuery); // Adjust this line if the id is a different type
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Students: ${totalStudents == -1 ? 'Loading...' : totalStudents}',
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 60),
                Text(
                  'Total Courses: ${totalCourses == -1 ? 'Loading...' : totalCourses}',
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value; // Update the search query
                });
              },
              decoration: InputDecoration(
                labelText: 'Search Students',
                border: OutlineInputBorder(),
                suffixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            if (searchQuery.isNotEmpty) ...[
              Expanded(
                child: ListView.builder(
                  itemCount: filteredLearners.length,
                  itemBuilder: (context, index) {
                    final learner = filteredLearners[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 2.0,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  learner.fullName,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text('ID: ${learner.learnerId}'),
                                const SizedBox(height: 4.0),
                                Text('Section: ${learner.group}'),
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
                                        builder: (BuildContext context) =>
                                            LearnerEditPage(learner: learner),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    _deleteLearner(learner.learnerId);
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
          ],
        ),
      ),
    );
  }
}
