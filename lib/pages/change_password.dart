import 'package:flutter/material.dart';
import 'package:sarims_todo_app/data_ops/user_session_local_ops.dart';

import '../data_ops/user_session_cloud_ops.dart';


class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  final TextEditingController newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: Make UI for change password page
    return Scaffold();
  }

  Future<void> changePassword() async {
    if (await changePasswordOnServer(newPasswordController.text)) {
      saveLoginInfoToDevice(getSessionUsername(), newPasswordController.text);
    };
  }

}