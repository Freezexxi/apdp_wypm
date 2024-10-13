import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mhk_star_education/pages/shared_page.dart';
import 'package:mhk_star_education/pages/student_list.dart';
import 'package:mhk_star_education/pages/student_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCAMNpP-SDF67unSZD_7VUROLKIEAZm9Y4",
          authDomain: "mhk-star-education.firebaseapp.com",
          projectId: "mhk-star-education",
          storageBucket: "mhk-star-education.appspot.com",
          messagingSenderId: "562118371848",
          appId: "1:562118371848:web:a68ff27d64ca6eea4f7fbd",
          measurementId: "G-1KDRE12MWE"),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(App());
}

class App extends StatelessWidget {

  const App({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Star Education Centre',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade400,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.cyan),
        useMaterial3: true,
      ),

      home: const SharedPage(),
    );
  }
}
