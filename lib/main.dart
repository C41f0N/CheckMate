import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sarims_todo_app/data_ops/user_session_local_ops.dart';
import 'package:sarims_todo_app/pages/change_password.dart';
import 'package:sarims_todo_app/pages/home.dart';
import 'package:sarims_todo_app/pages/login.dart';
import 'package:sarims_todo_app/pages/register.dart';

Future<void> main() async {
  await Hive.initFlutter();

  await Hive.openBox("TASKS_LOCAL_DATABASE");
  await Hive.openBox("USER_SESSION_DATA");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Colors.purple;
    final scaffoldBackgroundColor = Colors.grey[900];
    return MaterialApp(
      title: 'Sarim\'s To-Do App',
      theme: ThemeData(
        primarySwatch: primaryColor,
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
        drawerTheme: const DrawerThemeData(
          backgroundColor: primaryColor
        )
      ),
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
