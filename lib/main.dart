import 'package:flutter/material.dart';
import 'package:sarims_todo_app/pages/home.dart';

void main() {
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
      home: HomePage(),
    );
  }
}
