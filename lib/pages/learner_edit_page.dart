import 'package:flutter/material.dart';
import 'package:wypm_apdp/classes/course_program.dart';
import 'package:wypm_apdp/classes/learner.dart';
import 'package:wypm_apdp/custom_widgets/custom_text_field.dart';
import 'package:wypm_apdp/custom_widgets/display_status.dart';
import 'package:wypm_apdp/custom_widgets/enrollment_record_table.dart';
import 'package:wypm_apdp/data.dart';
import 'package:wypm_apdp/methods/course_program_methods.dart';
import 'package:wypm_apdp/methods/student_methods.dart';

class LearnerEditPage extends StatefulWidget {
  final Learner learner;

  const LearnerEditPage({super.key, required this.learner});

  @override
  State<LearnerEditPage> createState() => _LearnerEditPageState();
}

class _LearnerEditPageState extends State<LearnerEditPage> {
  final TextEditingController _nameCon = TextEditingController();
  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _phoneCon = TextEditingController();
  final TextEditingController _addressCon = TextEditingController();
  String? _gender;
  String? _sectionValue;
  List<CourseProgram> _selectedCourses = [];
  List<CourseProgram> _availableCourses = [];
  List<CourseProgram> _newSelectedCourses = [];
  double _finalCourseFee = 0;
  double _discount = 0;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  void _resetCourses() {
    setState(() {
      _newSelectedCourses = [];
    });
  }

  void _calculateDiscount() {
    switch (_selectedCourses.length) {
      case 0:
        _discount = 0;
      case 1:
        _discount = 5;
      case 2:
        _discount = 10;
      default:
        _discount = 20;
    }
  }

  void _initializeLearnerData() {
    // Initialize the controllers with the learner's current data
    _nameCon.text = widget.learner.fullName;
    _emailCon.text = widget.learner.emailAddress;
    _phoneCon.text = widget.learner.contactNumber;
    _addressCon.text = widget.learner.homeAddress;
    _sectionValue = widget.learner.group;
    _gender = widget.learner.genderIdentity;

    for (var i in _availableCourses) {
      if (widget.learner.enrolledCourses.contains(i.programId)) {
        _selectedCourses.add(i);
      }
    }
    _updateTotalFees();
    _calculateDiscount();
  }

  void _fetchCourses() async {
    CourseProgramMethods methods = CourseProgramMethods();
    List<CourseProgram> courses = await methods.fetchAllCoursePrograms();
    setState(() {
      _availableCourses = courses;
    });
    _initializeLearnerData();
  }

  void _onNewCourseSelectionChanged(List<CourseProgram> newSelectedCourses) {
    setState(() {
      _newSelectedCourses = newSelectedCourses;
      _updateTotalFees();
    });
  }

  void _updateTotalFees() {
    setState(() {
      _finalCourseFee = 0;
      for (var course in _newSelectedCourses) {
        _finalCourseFee += course.feeInMMK;
      }
      ;

      // Calculate discount amount
      double discountAmount = _finalCourseFee * (_discount / 100);

      // Calculate final fee
      _finalCourseFee = _finalCourseFee - discountAmount;
    });
  }

  Future<void> _saveChanges() async {
    LearnerMethods methods = LearnerMethods();

    if (_formKey.currentState!.validate()) {
      // Update the learner object with the new values
      Learner updatedLearner = Learner.learnerFactory(
        widget.learner.id,
        _nameCon.text,
        _emailCon.text,
        _phoneCon.text,
        _addressCon.text,
        widget.learner.joinedDate,
        _sectionValue!,
        _gender!,
        widget.learner.enrolledCourses,
      );

      // Save the updated learner details
      bool success = await methods.updateLearner(updatedLearner);

      if (success) {
        displayStatus(context, "Update Successful");
        // Optionally update course enrollments
        if (_newSelectedCourses.isNotEmpty) {
          bool status = await methods.enrollLearnerInCourses(
              updatedLearner, _newSelectedCourses);
          if (status) {
            displayStatus(context, "Courses Updated Successfully!");
            _fetchCourses();
          } else {
            displayStatus(context, "Error Updating Courses!");
          }
        }
      } else {
        displayStatus(context, "Update Failed");
      }
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Edit Learner Information",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'Edit Learner Information',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomTextField(
                    controller: _nameCon,
                    placeholder: 'Enter Full Name',
                    borderColor: Colors.orange,
                    borderRadius: 12,
                    placeholderColor: Colors.orange.shade300,
                    backgroundColor: Colors.orange.shade50,
                    isFilled: true,
                    textStyle: const TextStyle(color: Colors.orange),
                    prefixIcon: const Icon(Icons.person, color: Colors.orange),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the learner\'s full name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _emailCon,
                    placeholder: 'Email',
                    borderColor: Colors.orange,
                    borderRadius: 12,
                    placeholderColor: Colors.orange.shade300,
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
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _phoneCon,
                    placeholder: 'Phone Number',
                    borderColor: Colors.orange,
                    borderRadius: 12,
                    placeholderColor: Colors.orange.shade300,
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
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _addressCon,
                    placeholder: 'Address',
                    borderColor: Colors.orange,
                    borderRadius: 12,
                    placeholderColor: Colors.orange.shade300,
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
                  DropdownButtonFormField<String>(
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
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Select Gender',
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Male', child: Text('Male')),
                      DropdownMenuItem(value: 'Female', child: Text('Female')),
                      DropdownMenuItem(value: 'Other', child: Text('Other')),
                    ],
                    value: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Courses Enrolled",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 9),
                  SingleChildScrollView(
                    child: _CourseListWidget(
                      coursesAvailable: _availableCourses,
                      selectedCourses: _selectedCourses,
                      newSelectedCourses: _newSelectedCourses,
                      onCourseSelectionChanged: _onNewCourseSelectionChanged,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Discount: $_discount %',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        'Final Fee: $_finalCourseFee MMK',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _resetCourses,
                          child: const Text('Reset Courses'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveChanges,
                          child: const Text('Save Changes'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Enrollment Records!",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  FittedBox(
                    alignment: Alignment.center,
                    child: EnrollmentRecordTable(
                        learnerId: widget.learner.learnerId),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CourseListWidget extends StatelessWidget {
  final List<CourseProgram> coursesAvailable;
  final List<CourseProgram> selectedCourses;
  final List<CourseProgram> newSelectedCourses;
  final Function(List<CourseProgram>) onCourseSelectionChanged;

  const _CourseListWidget({
    Key? key,
    required this.coursesAvailable,
    required this.selectedCourses,
    required this.onCourseSelectionChanged,
    required this.newSelectedCourses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: coursesAvailable.length,
      itemBuilder: (context, index) {
        CourseProgram course = coursesAvailable[index];

        // Check if the course is already enrolled
        bool isEnrolled = selectedCourses.contains(course);
        bool isNewSelected = newSelectedCourses.contains(course);

        return ListTile(
          title: Text(course.programName),
          trailing: isEnrolled
              ? const Icon(Icons.check, color: Colors.green)
              : Checkbox(
                  value: isNewSelected,
                  onChanged: (bool? selected) {
                    if (selected == true) {
                      onCourseSelectionChanged([...newSelectedCourses, course]);
                    } else {
                      onCourseSelectionChanged(
                        newSelectedCourses.where((c) => c != course).toList(),
                      );
                    }
                  },
                ),
          subtitle: isEnrolled
              ? const Text("enrolled", style: TextStyle(color: Colors.grey))
              : null,
        );
      },
    );
  }
}
