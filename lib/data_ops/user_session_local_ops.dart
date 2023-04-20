import 'package:hive_flutter/hive_flutter.dart';
import 'package:check_mate/data_ops/encryption.dart';

final _myBox = Hive.box("USER_SESSION_DATA");
final _taskDbBox = Hive.box("TASKS_LOCAL_DATABASE");

void setLoginStatus(bool loggedIn) {
  _myBox.put("LOGGED_IN", loggedIn);
}

bool getLoginStatus() {
  return _myBox.get("LOGGED_IN") ?? false;
}

String getSessionUsername() {
  return _myBox.get("SESSION_USERNAME") ?? "";
}

String getSessionPasswordHash() {
  return _myBox.get("SESSION_PASSWORD_HASH") ?? "";
}

String getSessionEncryptionKey() {
  return _myBox.get("SESSION_ENCRYPTION_KEY") ?? "";
}

Future<void> saveLoginInfoToDevice(String username, String password) async {
  // store username
  _myBox.put("SESSION_USERNAME", username);

  // store password hash
  _myBox.put("SESSION_PASSWORD_HASH", await hashPass(password));

  // generate and store encryption key
  _myBox.put(
      "SESSION_ENCRYPTION_KEY", await generate32CharEncryptionCode(password));

  // Delete any existing tasks stored on device
  _taskDbBox.put("USER_TASKS_DATA", null);

  // set login status to true
  _myBox.put("LOGGED_IN", true);
}

void removeLoginInfoFromDevice() {
  // remove username
  _myBox.put("SESSION_USERNAME", null);

  // remove password hash
  _myBox.put("SESSION_PASSWORD_HASH", null);

  // remove encryption key
  _myBox.put("SESSION_ENCRYPTION_KEY", null);

  // set login status to false
  _myBox.put("LOGGED_IN", false);

  // Clear any planned upload events for future
  _myBox.put("SERVER_UPDATE_NEEDED", false);

  // Delete any existing tasks stored on device
  _taskDbBox.put("USER_TASKS_DATA", null);
}
