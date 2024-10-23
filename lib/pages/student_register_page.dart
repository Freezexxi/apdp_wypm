import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wypm_apdp/classes/course_program.dart';
import 'package:wypm_apdp/classes/learner.dart';
import 'package:wypm_apdp/custom_widgets/custom_text_field.dart';
import 'package:wypm_apdp/custom_widgets/display_status.dart';
import 'package:wypm_apdp/custom_widgets/log_out_button.dart';
import 'package:wypm_apdp/custom_widgets/refresh_button.dart';
import 'package:wypm_apdp/data.dart';
import 'package:wypm_apdp/methods/course_program_methods.dart';
import 'package:wypm_apdp/methods/student_methods.dart';

class StudentRegisterPage extends StatefulWidget {
  const StudentRegisterPage({super.key});

  @override
  State<StudentRegisterPage> createState() => _StudentRegisterPageState();
}

class _StudentRegisterPageState extends State<StudentRegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Student Registration Page",
          style: TextStyle(color: Colors.orange),
        ),
        actions: [
          RefreshButton(),
          const SizedBox(
            width: 5,
          ),
          const LogOutButton(),
        ],
        backgroundColor: Colors.black,
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
        child: const SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _StuRegisterForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StuRegisterForm extends StatefulWidget {
  const _StuRegisterForm();

  @override
  State<_StuRegisterForm> createState() => _StuRegisterFormState();
}

class _StuRegisterFormState extends State<_StuRegisterForm> {
  final TextEditingController _nameCon = TextEditingController();
  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _phoneCon = TextEditingController();
  final TextEditingController _addressCon = TextEditingController();
  String? _gender;
  String? _sectionValue;
  List<CourseProgram> _selectedCourses = [];
  List<CourseProgram> _availableCourses = [];
  double _totalCourseFees = 0;

  final _formKey = GlobalKey<FormState>();

  void _onCourseSelectionChanged(List<CourseProgram> selectedCourses) {
    setState(() {
      _selectedCourses = [];

      for (CourseProgram c in selectedCourses) {
        _selectedCourses.add(c);
      }

      _updateTotalFees();
    });
  }

  void _updateTotalFees() {
    setState(() {
      _totalCourseFees = 0;
      for (var course in _selectedCourses) {
        _totalCourseFees += course.feeInMMK;
      }
    });
  }

  void resetFields() {
    setState(() {
      _nameCon.clear();
      _emailCon.clear();
      _phoneCon.clear();
      _addressCon.clear();
      _sectionValue = null;
      _selectedCourses.clear();
      _gender = null;
    });
  }

  Future<void> registerStudent() async {
    LearnerMethods methods = LearnerMethods();

    if (_formKey.currentState!.validate()) {
      var uniqueId = uuidGenerator.v1();
      final DateTime startDate = DateTime.now();

      // Create new object
      Learner newLearner = Learner.learnerFactory(
        uniqueId,
        _nameCon.text,
        _emailCon.text,
        _phoneCon.text,
        _addressCon.text,
        Timestamp.fromDate(startDate),
        _sectionValue!,
        _gender!,
        [],
      );

      // Register the student
      String learnerId = await methods.addLearner(newLearner);

      if (learnerId.isNotEmpty) {
        displayStatus(context, "Registration Successful");
        if (_selectedCourses.isNotEmpty) {
          bool status = await methods.enrollLearnerInCourses(
              newLearner, _selectedCourses);
          if (status) {
            displayStatus(context, "Courses Enrolled!");
          } else {
            displayStatus(context, "Error Course Enrollment!");
          }
        }
      } else {
        displayStatus(context, "Registration Failed");
      }
    }
  }

  Future<void> fetchCourses() async {
    CourseProgramMethods methods = CourseProgramMethods();
    List<CourseProgram> courses = await methods.fetchAllCoursePrograms();
    setState(() {
      _availableCourses = courses;
    });
  }

  @override
  void initState() {
    fetchCourses();
    super.initState();
  }

  @override
  void dispose() {
    _nameCon.dispose();
    _emailCon.dispose();
    _phoneCon.dispose();
    _addressCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'New Student Registration',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _nameCon,
                      placeholder: 'Enter Star Student Full Name',
                      borderColor: Colors.orange,
                      borderRadius: 12,
                      placeholderColor: Colors.orange,
                      backgroundColor: Colors.orange.shade50,
                      isFilled: true,
                      textStyle: const TextStyle(color: Colors.orange),
                      prefixIcon:
                          const Icon(Icons.person, color: Colors.orange),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the learner\'s full name';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _emailCon,
                      placeholder: 'Enter Star Student Email',
                      borderColor: Colors.orange,
                      borderRadius: 12,
                      placeholderColor: Colors.orange,
                      backgroundColor: Colors.orange.shade50,
                      isFilled: true,
                      textStyle: const TextStyle(color: Colors.orange),
                      prefixIcon: const Icon(Icons.email, color: Colors.orange),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the learner\'s email';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _phoneCon,
                      placeholder: 'Enter Star Student Phone Number',
                      borderColor: Colors.orange,
                      borderRadius: 12,
                      placeholderColor: Colors.orange,
                      backgroundColor: Colors.orange.shade50,
                      isFilled: true,
                      textStyle: const TextStyle(color: Colors.orange),
                      prefixIcon: const Icon(Icons.phone, color: Colors.orange),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the learner\'s phone number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _addressCon,
                placeholder: 'Enter Star Student Address',
                borderColor: Colors.orange,
                borderRadius: 12,
                placeholderColor: Colors.orange,
                backgroundColor: Colors.orange.shade50,
                isFilled: true,
                textStyle: const TextStyle(color: Colors.orange),
                minLines: 2,
                maxLines: 4,
                prefixIcon: const Icon(Icons.home, color: Colors.orange),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the learner\'s address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Select Section',
                      ),
                      items: studentSections.map((String section) {
                        return DropdownMenuItem<String>(
                          value: section,
                          child: Text(section),
                        );
                      }).toList(),
                      value: _sectionValue,
                      onChanged: (value) {
                        setState(() {
                          _sectionValue = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Select Gender',
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Male', child: Text('Male')),
                        DropdownMenuItem(
                            value: 'Female', child: Text('Female')),
                        DropdownMenuItem(value: 'Other', child: Text('Other')),
                      ],
                      value: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Optional Course: Select course to apply!",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 9),
              _CourseListWidget(
                coursesAvailable: _availableCourses,
                selectedCourses: _selectedCourses,
                onCourseSelectionChanged: _onCourseSelectionChanged,
              ),
              Text(
                "Total Cost is: $_totalCourseFees MMK",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: resetFields,
                    child: const Text('Reset'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.all(20),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    onPressed: registerStudent,
                    child: const Text('Register Student'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.all(20),
                      textStyle:
                          const TextStyle(fontSize: 18, color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CourseListWidget extends StatefulWidget {
  final List<CourseProgram> selectedCourses;
  final List<CourseProgram> coursesAvailable;
  final Function(List<CourseProgram>) onCourseSelectionChanged;

  const _CourseListWidget({
    Key? key,
    required this.selectedCourses,
    required this.coursesAvailable,
    required this.onCourseSelectionChanged,
  }) : super(key: key);

  @override
  _CourseListWidgetState createState() => _CourseListWidgetState();
}

class _CourseListWidgetState extends State<_CourseListWidget> {
  @override
  Widget build(BuildContext context) {
    List<CourseProgram> allCourses = widget.coursesAvailable;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: allCourses.length,
      itemBuilder: (context, index) {
        final course = allCourses[index];
        final isSelected = widget.selectedCourses.contains(course);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                widget.selectedCourses.remove(course);
              } else {
                widget.selectedCourses.add(course);
              }
              widget.onCourseSelectionChanged(widget.selectedCourses);
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              course.programName,
              style: TextStyle(
                fontSize: 18,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}
