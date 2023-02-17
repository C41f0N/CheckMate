import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart';

Future<String> hashPass(String passcode) async {
  final message = passcode.codeUnits;
  final algorithm = Sha512();
  final hash = await algorithm.hash(message);
  return String.fromCharCodes(hash.bytes);
}

Future<String> generate32CharEncryptionCode(passcode) async {
  final message = passcode.codeUnits;
  final algorithm = Sha256();
  final hash = await algorithm.hash(message);
  return Uri.encodeFull(String.fromCharCodes(hash.bytes))
      .replaceAll("%", "")
      .substring(0, 32);
}

String encryptTaskData(String taskData, String encryptKey) {
  final key = Key.fromUtf8(encryptKey);
  final b64key = Key.fromBase64(base64Url.encode(key.bytes));
  final fernet = Fernet(b64key);
  final encrypter = Encrypter(fernet);

  return encrypter.encrypt("${taskData}ENCRYPTED_TASK_DATA").base64;
}

String decryptTaskData(String encryptedTaskData, String encryptKey) {
  final key = Key.fromUtf8(encryptKey);
  final b64key = Key.fromBase64(base64Url.encode(key.bytes));
  final fernet = Fernet(b64key);
  final encrypter = Encrypter(fernet);
  return encrypter.decrypt(Encrypted.fromBase64(encryptedTaskData));
}

bool verifyDecryptedData(String decryptedTaskData) {
  return decryptedTaskData
          .substring(decryptedTaskData.length - "ENCRYPTED_TASK_DATA".length) ==
      "ENCRYPTED_TASK_DATA";
}

String extractTaskData(String decryptedTaskData) {
  return decryptedTaskData.substring(
      0, decryptedTaskData.length - "ENCRYPTED_TASK_DATA".length);
}
