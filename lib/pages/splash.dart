import 'dart:async';

import 'package:check_mate/data_ops/user_session_local_ops.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, getLoginStatus() ? "/home" : "/login");
    });
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 15,
            ),
            Image.asset(
              "assets/images/icon/icon(rounded).png",
              height: 100,
              width: 100,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "CheckMate",
              style: TextStyle(
                color: Colors.grey[200],
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
