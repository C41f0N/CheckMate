import 'package:http/http.dart' as http;
import 'package:check_mate/data_ops/user_session_local_ops.dart';

Future<String> fetchEncryptedDataFromServer() async {
  // Load required data
  final username = getSessionUsername();
  final hash = getSessionPasswordHash();

  // Fetch raw data from server
  try {
    final result = await http.get(Uri.parse(
        'https://sarimahmed.tech/sarim-s_todo_app/get_task_data.php?username=${Uri.encodeComponent(username)}&hash=${Uri.encodeComponent(hash)}'));
    return result.body;
  } on Exception catch (_) {
    print(_.toString());
    return "";
  }
}

Future<String> uploadEncryptedDataToServer(encryptedData) async {
  // Load required data
  final username = getSessionUsername();
  final hash = getSessionPasswordHash();

  // Upload data to server
  try {
    final result = await http.get(Uri.parse(
        'https://sarimahmed.tech/sarim-s_todo_app/upload_task_data.php?username=${Uri.encodeComponent(username)}&hash=${Uri.encodeComponent(hash)}&task_data=${Uri.encodeComponent(encryptedData)}'));
    return result.body;
  } on Exception catch (_) {
    return "0";
  }
}
