import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:wypm_apdp/classes/course_program.dart';
import 'package:wypm_apdp/custom_widgets/display_status.dart';
import 'package:wypm_apdp/methods/course_program_methods.dart';

class ManageCoursePage extends StatefulWidget {
  const ManageCoursePage({super.key});

  @override
  State<ManageCoursePage> createState() => _ManageCoursePageState();
}

class _ManageCoursePageState extends State<ManageCoursePage> {
  final TextEditingController _programNameController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();
  final TextEditingController _overviewController = TextEditingController();
  final CourseProgramMethods _courseProgramMethods = CourseProgramMethods();

  String _selectedDifficulty = 'Beginner';
  List<CourseProgram> _courses = [];
  final _formKey = GlobalKey<FormState>();

  Future<void> _fetchCourse() async {
    List<CourseProgram> coursesFromDB = await _courseProgramMethods.fetchAllCoursePrograms();
    setState(() {
      _courses = coursesFromDB;
    });
  }

  Future<void> _registerCourse() async {
    if (_formKey.currentState!.validate()) {
      var newCourse = CourseProgram(
        programId: Uuid().v1(),
        programName: _programNameController.text,
        feeInMMK: double.parse(_feeController.text),
        overview: _overviewController.text,
        difficultyLevel: _selectedDifficulty,
      );

      bool status = await _courseProgramMethods.addCourseProgram(newCourse);

      if (status) {
        displayStatus(context, "Created Course Program");
      } else {
        displayStatus(context, "Error: Creating Course Program");
      }
      _resetForm();
      _fetchCourse();
    }
  }

  void _resetForm() {
    _programNameController.clear();
    _feeController.clear();
    _overviewController.clear();
    setState(() {
      _selectedDifficulty = 'Beginner';
    });
  }

  @override
  void initState() {
    _fetchCourse();
    super.initState();
  }

  @override
  void dispose() {
    _programNameController.dispose();
    _feeController.dispose();
    _overviewController.dispose();
    super.dispose();
  }

  Future<void> _showEditDialog(CourseProgram course) async {
    _programNameController.text = course.programName;
    _feeController.text = course.feeInMMK.toString();
    _overviewController.text = course.overview;
    _selectedDifficulty = course.difficultyLevel;

    // Show the dialog with prefilled fields
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Course'),
          content: Form(
            key: _formKey, // Use the same form key
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _programNameController,
                  decoration: const InputDecoration(labelText: 'Course Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the course name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _feeController,
                  decoration: const InputDecoration(labelText: 'Course Fee (MMK)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the course fee';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _overviewController,
                  decoration: const InputDecoration(labelText: 'Course Overview'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the course overview';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedDifficulty,
                  items: const [
                    DropdownMenuItem(value: 'Beginner', child: Text('Beginner')),
                    DropdownMenuItem(value: 'Intermediate', child: Text('Intermediate')),
                    DropdownMenuItem(value: 'Advanced', child: Text('Advanced')),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedDifficulty = newValue ?? 'Beginner';
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Difficulty Level'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Update the course details
                  var updatedCourse = CourseProgram(
                    programId: course.programId,
                    programName: _programNameController.text,
                    feeInMMK: double.parse(_feeController.text),
                    overview: _overviewController.text,
                    difficultyLevel: _selectedDifficulty,
                  );

                  bool status = await _courseProgramMethods.updateCourseProgram(updatedCourse);

                  if (status) {
                    displayStatus(context, "Updated Course Program");
                    _fetchCourse(); // Refresh the course list
                  } else {
                    displayStatus(context, "Error: Updating Course Program");
                  }
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Courses"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _CourseRegistrationForm(
                  formKey: _formKey,
                  programNameController: _programNameController,
                  feeController: _feeController,
                  overviewController: _overviewController,
                  selectedDifficulty: _selectedDifficulty,
                  onDifficultyChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedDifficulty = newValue;
                      });
                    }
                  },
                  onRegister: _registerCourse,
                ),
                const SizedBox(height: 20),
                _CourseList(
                  courses: _courses,
                  onEditCourse: _showEditDialog, // Pass the edit function
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CourseRegistrationForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController programNameController;
  final TextEditingController feeController;
  final TextEditingController overviewController;
  final String selectedDifficulty;
  final ValueChanged<String?> onDifficultyChanged;
  final VoidCallback onRegister;

  const _CourseRegistrationForm({
    required this.formKey,
    required this.programNameController,
    required this.feeController,
    required this.overviewController,
    required this.selectedDifficulty,
    required this.onDifficultyChanged,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Register a New Course',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Course Name',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: programNameController,
              decoration:
              const InputDecoration(labelText: 'Enter program name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter program name';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            const Text(
              'Course Fee (MMK)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: feeController,
              decoration: const InputDecoration(labelText: 'Enter course fee'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter course fee';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            const Text(
              'Overview',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: overviewController,
              decoration:
              const InputDecoration(labelText: 'Enter course overview'),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter course overview';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            const Text(
              'Difficulty Level',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField<String>(
              value: selectedDifficulty,
              items: const [
                DropdownMenuItem(value: 'Beginner', child: Text('Beginner')),
                DropdownMenuItem(
                    value: 'Intermediate', child: Text('Intermediate')),
                DropdownMenuItem(value: 'Advanced', child: Text('Advanced')),
              ],
              onChanged: onDifficultyChanged,
              decoration: const InputDecoration(labelText: 'Select difficulty'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onRegister,
                child: const Text('Create Course'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseList extends StatelessWidget {
  final List<CourseProgram> courses;
  final Function(CourseProgram) onEditCourse;

  const _CourseList({required this.courses, required this.onEditCourse});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: courses.map((course) {
        return ListTile(
          title: Text(course.programName),
          subtitle: Text(
              "Fee: ${course.feeInMMK} MMK, Level: ${course.difficultyLevel}"),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              onEditCourse(course); // Trigger the edit function
            },
          ),
        );
      }).toList(),
    );
  }
}
