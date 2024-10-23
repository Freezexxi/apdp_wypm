import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wypm_apdp/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCUigxH9KJ42CW5elo8Rbi8U8cL_JFpCU8",
          authDomain: "apass1bywypm.firebaseapp.com",
          projectId: "apass1bywypm",
          storageBucket: "apass1bywypm.appspot.com",
          messagingSenderId: "206112462960",
          appId: "1:206112462960:web:8fea99ffe8e8b0895a7cb5",
          measurementId: "G-0Z0ZK3XKWE"),
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
      home: const LoginPage(),
    );
  }
}
