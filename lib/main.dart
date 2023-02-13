import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sarims_todo_app/pages/home.dart';

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
      ),
      home: const HomePage(),
    );
  }
}
