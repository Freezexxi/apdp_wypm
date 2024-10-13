import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mhk_star_education/objects/course.dart';
import 'package:mhk_star_education/objects/methods/student_methods.dart';
import 'package:mhk_star_education/objects/student.dart';
import 'package:mhk_star_education/static_data.dart';
import 'package:mhk_star_education/utils/status_show.dart';
import 'package:mhk_star_education/utils/widget_text_field.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Student Registration",
          style: TextStyle(color: Colors.white),
        ),
        actions: const [
          // IconButton(onPressed: (){Navigator.pushReplacement(context, newRoute)}, icon: icon)
        ],
        backgroundColor: Colors.teal,
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _StuRegisterForm(),
            ],
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
  final List<Course> enrolledCourse = [];
  final List<Course> _selectedCourses = [];
  double _totalCourseFees = 0;

  final _formKey = GlobalKey<FormState>();

  void _updateTotalFees() {
    setState(() {
      _totalCourseFees = 0;
      for (var course in _selectedCourses) {
        _totalCourseFees += course.courseFee;
      }
    });
  }

  Future<void> registerStudent() async {
    String? currentStudentId;
    StudentMethods studentMethods = StudentMethods();

    if (_formKey.currentState!.validate()) {
      var uniqueId = uuid.v1();
      final DateTime startDate = DateTime.now();

      // Create new student object
      Student s1 = Student.studentFactory(
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
      String id = await studentMethods.register(s1);

      if (id.isNotEmpty) {
        StatusShow(context, "Registration Successful");
        currentStudentId = id;
      } else {
        StatusShow(context, "Registration Failed");
      }

      if (id.isNotEmpty) {
        // Enroll the student in selected courses
        if (_selectedCourses.isNotEmpty) {
          bool response =
              await studentMethods.enrollCourses(s1, _selectedCourses);
          if (response) {
            StatusShow(context, "Courses Enrolled Successfully");
          } else {
            StatusShow(context, "Course Enrollment Failed");
          }
        }
      }



      // Clear fields after successful registration
      setState(() {
        _nameCon.clear();
        _emailCon.clear();
        _phoneCon.clear();
        _addressCon.clear();
        _sectionValue = null;
        _selectedCourses.clear();
      });
    }
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
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: WidgetTextField(
                      controller: _nameCon,
                      hintText: 'Full Name',
                      borderColor: Colors.teal,
                      borderRadius: 12,
                      hintColor: Colors.teal.shade300,
                      fillColor: Colors.teal.shade50,
                      filled: true,
                      textStyle: const TextStyle(color: Colors.teal),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the student\'s full name';
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
                    child: WidgetTextField(
                      controller: _emailCon,
                      hintText: 'Email',
                      borderColor: Colors.teal,
                      borderRadius: 12,
                      hintColor: Colors.teal.shade300,
                      fillColor: Colors.teal.shade50,
                      filled: true,
                      textStyle: const TextStyle(color: Colors.teal),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the student\'s email';
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
                    child: WidgetTextField(
                      controller: _phoneCon,
                      hintText: 'Phone Number',
                      borderColor: Colors.teal,
                      borderRadius: 12,
                      hintColor: Colors.teal.shade300,
                      fillColor: Colors.teal.shade50,
                      filled: true,
                      textStyle: const TextStyle(color: Colors.teal),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the student\'s phone number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              WidgetTextField(
                controller: _addressCon,
                hintText: 'Address',
                borderColor: Colors.teal,
                borderRadius: 12,
                hintColor: Colors.teal.shade300,
                fillColor: Colors.teal.shade50,
                filled: true,
                textStyle: const TextStyle(color: Colors.teal),
                minLines: 2,
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the student\'s address';
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
                      items: sections.map((String section) {
                        return DropdownMenuItem<String>(
                          value: section,
                          child: Text(section),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _sectionValue = newValue;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Select Gender',
                      ),
                      items: ['Male', 'Female'].map((String gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _gender = newValue;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  onPressed: registerStudent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: courses.length * 50,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (BuildContext context, int index) {
                    final course = courses[index];
                    return CheckboxListTile(
                      title: Text(course.name),
                      subtitle: Text(
                          "Fee: ${course.courseFee.toStringAsFixed(2)} MMK"),
                      value: _selectedCourses.contains(course),
                      onChanged: (bool? selected) {
                        setState(() {
                          if (selected == true) {
                            _selectedCourses.add(course);
                          } else {
                            _selectedCourses.remove(course);
                          }
                        });
                        _updateTotalFees();
                      },
                    );
                  },
                ),
              ),
              Text(
                "Total Fees: $_totalCourseFees MMK",
                style: const TextStyle(
                  fontSize: 14,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
