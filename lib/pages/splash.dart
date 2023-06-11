import 'dart:async';

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
  // Tick colors initially null
  Color tick1ColorInitial = const Color.fromARGB(255, 255, 202, 0);
  Color tick2ColorInitial = const Color.fromARGB(255, 255, 144, 8);
  Color tick3ColorInitial = const Color.fromARGB(255, 255, 91, 26);

  Color tick1ColorFinal = currentTheme.getCurrentPrimarySwatch();
  Color tick2ColorFinal = currentTheme.getCurrentPrimarySwatch();
  Color tick3ColorFinal = currentTheme.getCurrentPrimarySwatch();

  late AnimationController _controller;
  late Animation<double> _logoColorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _logoColorAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.addListener(() {
      setState(() {});
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(
              context, getLoginStatus() ? "/home" : "/login");
        });
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 15,
            ),
            Container(
              alignment: Alignment.center,
              width: 140,
              height: 140,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    "assets/images/icon/seperate/bg(rounded).png",
                    height: 100,
                    width: 100,
                  ),
                  Transform.translate(
                    offset: const Offset(2, 4),
                    child: Stack(
                      children: [
                        Image.asset(
                          "assets/images/icon/seperate/tick1.png",
                          height: 140,
                          width: 140,
                          color: Color.alphaBlend(
                              tick3ColorFinal
                                  .withOpacity(0.3 * _logoColorAnimation.value),
                              tick3ColorInitial
                                  .withOpacity(1 - _logoColorAnimation.value)),
                        ),
                        Image.asset(
                          "assets/images/icon/seperate/tick2.png",
                          height: 140,
                          width: 140,
                          color: Color.alphaBlend(
                              tick2ColorFinal
                                  .withOpacity(0.6 * _logoColorAnimation.value),
                              tick2ColorInitial
                                  .withOpacity(1 - _logoColorAnimation.value)),
                        ),
                        Image.asset(
                          "assets/images/icon/seperate/tick3.png",
                          height: 140,
                          width: 140,
                          color: Color.alphaBlend(
                              tick1ColorFinal
                                  .withOpacity(1.0 * _logoColorAnimation.value),
                              tick1ColorInitial
                                  .withOpacity(1 - _logoColorAnimation.value)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              "CheckMate",
              style: TextStyle(
                color: Colors.grey[200],
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
