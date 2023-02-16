import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:sarims_todo_app/data_ops/encryption.dart';

// Function to verify username
Future<bool> verifyUsername(String username) async {
  try {
    var result = await http.get(Uri.parse(
        'https://sarimahmed.tech/sarim-s_todo_app/user_exists_check.php?username=${Uri.encodeComponent(username)}'));
    return result.body == "1";
  } on SocketException catch (_) {
    return false;
  }
}

// Function to verify password
Future<bool> verifyPassword(String username, String password) async {

  final String hash = await hashPass(password);

  try {
    var result = await http.get(Uri.parse(
        'https://sarimahmed.tech/sarim-s_todo_app/verify_pass.php?username=${Uri.encodeComponent(username)}&hash=${Uri.encodeComponent(hash)}'));
    return result.body == "1";
  } on SocketException catch (_) {
    return false;
  }
}