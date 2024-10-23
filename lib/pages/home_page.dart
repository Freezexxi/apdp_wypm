import 'package:flutter/material.dart';
import 'package:wypm_apdp/classes/learner.dart';
import 'package:wypm_apdp/custom_widgets/display_status.dart';
import 'package:wypm_apdp/custom_widgets/log_out_button.dart';
import 'package:wypm_apdp/custom_widgets/refresh_button.dart';
import 'package:wypm_apdp/methods/course_program_methods.dart';
import 'package:wypm_apdp/methods/student_methods.dart';

import 'learner_edit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int totalStudents = -1;
  int totalCourses = -1;
  String searchQuery = '';
  final LearnerMethods _learnerMethods = LearnerMethods();
  final CourseProgramMethods _courseProgramMethods = CourseProgramMethods();
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
          learner.learnerId.toString().contains(searchQuery);
    }).toList();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'Home Page',
            style: TextStyle(
              color: Colors.orange,
            ),
          ),
          actions: [
            RefreshButton(),
            const SizedBox(width: 5),
            const LogOutButton(),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.orange.shade900,
              Colors.orange.shade800,
              Colors.orange.shade400,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enrolled Total Star Students 🧑‍🎓: ${totalStudents == -1 ? 'Loading...' : totalStudents}',
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 60),
                  Text(
                    'Current Total Star Courses 📚: ${totalCourses == -1 ? 'Loading...' : totalCourses}',
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Search Students',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
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
      ),
    );
  }
}
