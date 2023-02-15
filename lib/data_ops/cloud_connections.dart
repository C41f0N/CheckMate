import 'dart:io';

import 'package:http/http.dart' as http;

Future<bool> verifyUsername(String username) async {
  try {
    var result = await http.get(Uri.parse(
        'https://sarimahmed.tech/sarim-s_todo_app/user_exists_check.php?username=${Uri.encodeComponent(username)}'));
    return result.body == "1";
  } on SocketException catch (_) {
    return false;
  }
}
