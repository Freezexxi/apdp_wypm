import 'package:flutter/material.dart';
import 'package:wypm_apdp/pages/home_page.dart';
import 'package:wypm_apdp/pages/manage_course_page.dart';
import 'package:wypm_apdp/pages/student_list_page.dart';
import 'package:wypm_apdp/pages/student_register_page.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const StudentRegisterPage(),
    const StudentListPage(),
    const ManageCoursePage()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt),
            label: 'Learners',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_sharp),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_sharp
            ),
            label: 'Manage Courses',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.blueGrey,
        onTap: onTabTapped,
      ),
    );
  }
}
