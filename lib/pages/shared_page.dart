import 'package:flutter/material.dart';
import 'package:mhk_star_education/pages/home_page.dart';
import 'package:mhk_star_education/pages/student_list.dart';
import 'package:mhk_star_education/pages/student_page.dart';

class SharedPage extends StatefulWidget {
  const SharedPage({super.key});

  @override
  State<SharedPage> createState() => _SharedPageState();
}

class _SharedPageState extends State<SharedPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const StudentPage(),
    const StudentList(),
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
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Courses',
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
