import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:check_mate/config.dart';
import 'package:flutter/material.dart';

import '../data_ops/user_session_local_ops.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(
          context, getLoginStatus() ? "/home" : "/login");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AutoSizeText(
          "CheckMate",
          style: TextStyle(
            fontWeight: FontWeight.w200,
            color: Theme.of(context).colorScheme.primary,
            fontSize: 40,
          ),
        ),
      ),
    );
  }
}
