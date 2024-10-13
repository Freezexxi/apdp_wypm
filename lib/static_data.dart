import 'package:mhk_star_education/objects/course.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

const String loginEmail = "email@example.com";
const String loginPassword = 'abcdefghi';

const List<String> sections = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
List<Course> courses = [
  Course(
    name: "Basic Web Development",
    courseFee: 200000,
    courseOverview:
        "Learn the fundamentals of web development, including HTML, CSS, and JavaScript.",
    teacherName: "U Aung Myint",
  ),
  Course(
    name: "Advanced JavaScript Programming",
    courseFee: 350000,
    courseOverview:
        "Master advanced JavaScript concepts, including ES6+, async programming, and web APIs.",
    teacherName: "Daw Su Su Lwin",
  ),
  Course(
    name: "Full-Stack Development with MERN",
    courseFee: 500000,
    courseOverview:
        "Become proficient in full-stack development using MongoDB, Express, React, and Node.js.",
    teacherName: "U Kyaw Zaw Lin",
  ),
  Course(
    name: "Mobile App Development with Flutter",
    courseFee: 600000,
    courseOverview: "Build cross-platform mobile apps using Flutter and Dart.",
    teacherName: "Daw Hla Hla Win",
  ),
  Course(
    name: "Backend Development with Node.js",
    courseFee: 700000,
    courseOverview:
        "Develop backend services and APIs using Node.js and Express.",
    teacherName: "U Soe Min Tun",
  ),
];
