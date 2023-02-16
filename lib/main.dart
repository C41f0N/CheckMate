import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sarims_todo_app/pages/home.dart';
import 'package:sarims_todo_app/pages/login.dart';

Future<void> main() async {
  await Hive.initFlutter();

  await Hive.openBox("TASKS_LOCAL_DATABASE");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sarim\'s To-Do App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.grey[900],
        dialogBackgroundColor: Colors.grey[900],
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[850],
          focusColor: Colors.grey[800],
          labelStyle: TextStyle(color: Colors.grey[400]),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.purple.withAlpha(170),
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
      ),
      home: const HomePage(),
    );
  }
}
