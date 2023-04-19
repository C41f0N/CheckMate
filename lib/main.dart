import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:check_mate/config.dart';
import 'package:check_mate/data_ops/user_session_local_ops.dart';
import 'package:check_mate/pages/change_password.dart';
import 'package:check_mate/pages/home.dart';
import 'package:check_mate/pages/login.dart';
import 'package:check_mate/pages/register.dart';

Future<void> main() async {
  await Hive.initFlutter();

  await Hive.openBox("TASKS_LOCAL_DATABASE");
  await Hive.openBox("USER_SESSION_DATA");
  await Hive.openBox("THEME_DATA");

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = currentTheme.getCurrentPrimarySwatch();
    final scaffoldBackgroundColor = Colors.grey[900];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'checkMate',
      theme: ThemeData(
          primarySwatch: primaryColor,
          primaryColor: primaryColor,
          scaffoldBackgroundColor: scaffoldBackgroundColor,
          dialogBackgroundColor: scaffoldBackgroundColor,
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey[850],
            focusColor: Colors.grey[800],
            labelStyle: TextStyle(color: Colors.grey[400]),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: primaryColor.withAlpha(170),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Colors.red.withAlpha(170),
              ),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          drawerTheme: DrawerThemeData(
            backgroundColor: primaryColor.withAlpha(200),
          ),
          iconTheme: IconThemeData(
              color:
                  currentTheme.isDark() ? Colors.grey[900] : Colors.grey[100]!),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style:
                  ElevatedButton.styleFrom(foregroundColor: Colors.grey[900]))),
      initialRoute: getLoginStatus() ? '/home' : '/login',
      routes: {
        '/home': ((context) => const HomePage()),
        '/login': ((context) => const LoginPage()),
        '/register': ((context) => const RegisterPage()),
        '/change_password': ((context) => const ChangePasswordPage()),
      },
    );
  }
}
