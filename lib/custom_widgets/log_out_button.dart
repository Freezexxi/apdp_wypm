import 'package:flutter/material.dart';
import 'package:wypm_apdp/pages/login_page.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => LoginPage(),
          ),
        );
      },
      icon: const Icon(
        Icons.logout_sharp,
        color: Colors.orangeAccent,
      ),
    );
  }
}
