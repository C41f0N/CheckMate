import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:sarims_todo_app/data_ops/encryption.dart';

// Function to verify username
Future<String> verifyUsername(String username) async {
  try {
    var result = await http.get(Uri.parse(
        'https://sarimahmed.tech/sarim-s_todo_app/user_exists_check.php?username=${Uri.encodeComponent(username)}'));
    if ((result.statusCode / 100).floor() == 2) {
      return result.body;
    } else {
      return "0";
    }
  } on Exception catch (_) {
    return "ERROR";
  }
}

// Function to verify password
Future<String> verifyPassword(String username, String password) async {
  final String hash = await hashPass(password);

  try {
    var result = await http.get(Uri.parse(
        'https://sarimahmed.tech/sarim-s_todo_app/verify_pass.php?username=${Uri.encodeComponent(username)}&hash=${Uri.encodeComponent(hash)}'));
    if ((result.statusCode / 100).floor() == 2) {
      return result.body;
    } else {
      return "0";
    }
  } on Exception catch (_) {
    return "ERROR";
  }
}

// Function register new user
Future<String> registerUser(String username, String password) async {
  final String hash = await hashPass(password);

  try {
    var result = await http.get(Uri.parse(
        'https://sarimahmed.tech/sarim-s_todo_app/add_user.php?username=${Uri.encodeComponent(username)}&hash=${Uri.encodeComponent(hash)}'));
    if ((result.statusCode / 100).floor() == 2) {
      return result.body;
    } else {
      return "0";
    }
  } on Exception catch (_) {
    return "ERROR";
  }
}
