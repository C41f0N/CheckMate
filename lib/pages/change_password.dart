// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:sarims_todo_app/config.dart';
import 'package:sarims_todo_app/data_ops/task_database_class.dart';
import '../data_ops/user_session_cloud_ops.dart';
import '../data_ops/user_session_local_ops.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController newPasswordVerifyController =
      TextEditingController();

  String? currentPasswordError;
  String? newPasswordVerifyError;
  bool processing = false;
  bool hidePassword = true;
  bool hideCurrentPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: InternetConnectivity().observeInternetConnection,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              bool hasConnection = snapshot.data!;
              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),

                      // Change Password Title
                      Text(
                        "Change\nPassword",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 35,
                          color: Colors.grey[200],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),

                      // Current Password Input Field
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8 > 320
                            ? 320
                            : MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          obscureText: hideCurrentPassword ||
                              processing ||
                              !hasConnection,
                          enabled: !processing && hasConnection,
                          controller: currentPasswordController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            errorText: currentPasswordError,
                            label: const Text("Current Password"),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hideCurrentPassword = !hideCurrentPassword;
                                  });
                                },
                                splashRadius: 5,
                                icon: Icon(
                                  hideCurrentPassword
                                      ? Icons.remove_red_eye
                                      : Icons.shield_outlined,
                                  color: Colors.grey[600],
                                )),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      // New Password Input Field
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8 > 320
                            ? 320
                            : MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          obscureText:
                              hidePassword || processing || !hasConnection,
                          enabled: !processing && hasConnection,
                          controller: newPasswordController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            errorText: newPasswordVerifyError,
                            label: const Text("New Password"),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                                splashRadius: 5,
                                icon: Icon(
                                  hidePassword
                                      ? Icons.remove_red_eye
                                      : Icons.shield_outlined,
                                  color: Colors.grey[600],
                                )),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      // Verify New Password Input Field
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8 > 320
                            ? 320
                            : MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          obscureText:
                              hidePassword || processing || !hasConnection,
                          enabled: !processing && hasConnection,
                          controller: newPasswordVerifyController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            errorText: newPasswordVerifyError,
                            label: const Text("Re-Enter New Password"),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                                splashRadius: 5,
                                icon: Icon(
                                  hidePassword
                                      ? Icons.remove_red_eye
                                      : Icons.shield_outlined,
                                  color: Colors.grey[600],
                                )),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // Login Button if connected, else warning message
                      GestureDetector(
                        onTap: (currentPasswordController.text.isNotEmpty &&
                                newPasswordController.text.isNotEmpty &&
                                newPasswordVerifyController.text.isNotEmpty)
                            ? changePassword
                            : () {},
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: hasConnection
                                ? Theme.of(context).colorScheme.primary
                                : Colors.red[900],
                          ),
                          alignment: Alignment.center,
                          height: 55,
                          width: MediaQuery.of(context).size.width * 0.8 > 320
                              ? 320
                              : MediaQuery.of(context).size.width * 0.8,
                          child: hasConnection
                              ? Text(
                                  'Change Password',
                                  style: TextStyle(
                                      color: currentTheme.isDark()
                                          ? Colors.grey[800]
                                          : Colors.white,
                                      fontWeight: FontWeight.w500),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons
                                        .signal_wifi_statusbar_connected_no_internet_4_rounded),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      "No Internet Connection :(",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.19),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/home', (Route<dynamic> route) => false);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.arrow_back,
                              size: 15,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Go Back")
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  // Change Password Function

  Future<void> changePassword() async {
    bool? currentPasswordValid;
    bool? newPasswordValid;
    bool? processSuccessful = false;

    //set status to: processing data
    setState(() {
      processing = true;
    });

    // Show loading Dialog
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) => AlertDialog(
              content: SizedBox(
                height: 100,
                child: Center(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text(
                      "Processing..",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )),
              ),
            )));

    // Get server data encrypted with current password
    final TaskDatabase db = TaskDatabase();
    await db.getTaskDataFromServer();

    // Check if current password is valid
    final currentPasswordResult = await verifyPassword(
        getSessionUsername(), currentPasswordController.text);
    if (currentPasswordResult != "ERROR") {
      if (currentPasswordResult == "1") {
        currentPasswordError = null;
        currentPasswordValid = true;
      } else {
        currentPasswordValid = false;
        currentPasswordError = "Incorrect current password.";
        newPasswordValid = false;
      }

      // If current password is valid
      if (currentPasswordValid) {
        // Verify New Password
        newPasswordValid =
            newPasswordController.text == newPasswordVerifyController.text;
        newPasswordVerifyError =
            newPasswordValid ? null : "Passwords do not match";

        if (currentPasswordValid && newPasswordValid) {
          if (await changePasswordOnServer(newPasswordController.text)) {
            processSuccessful = true;
          }
        }
      }
    }

    //set status to: not processing data
    setState(() {
      processing = false;
    });

    // If verification was successfully done, then do this
    if (processSuccessful) {
      await saveLoginInfoToDevice(
        getSessionUsername(),
        newPasswordController.text,
      );

      // encrypt data again with new key and upload
      await db.uploadDataToServer();

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password Changed Successfully.")));

      // Remove Dialog
      Navigator.of(context).pop();

      // Else show connection error
    } else {
      if (currentPasswordValid == true && newPasswordValid == true) {
        // Remove Dialog
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: ((context) => AlertDialog(
                title: const Text(
                  "There was a problem connecting to the server.",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                actions: [
                  ElevatedButton(
                      onPressed: (() {
                        Navigator.pop(context);
                      }),
                      child: const Text("Okay"))
                ],
              )),
        );
      }
    }
  }
}
