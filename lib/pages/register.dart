// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import '../config.dart';
import '../data_ops/user_session_cloud_ops.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController reEnterPasswordController =
      TextEditingController();
  String? usernameError;
  String? passwordError;
  bool processing = false;
  bool hidePassword = true;

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
                        height: MediaQuery.of(context).size.height * 0.24,
                      ),

                      // Register Title
                      Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 35,
                          color: Colors.grey[200],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),

                      // Username Input Field
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8 > 320
                            ? 320
                            : MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          controller: usernameController,
                          enabled: !processing && hasConnection,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            errorText: usernameError,
                            label: const Text("Username"),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      // Password Input Field
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8 > 320
                            ? 320
                            : MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          obscureText:
                              hidePassword || processing || !hasConnection,
                          enabled: !processing && hasConnection,
                          controller: passwordController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            errorText: passwordError,
                            label: const Text("Password"),
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8 > 320
                            ? 320
                            : MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          obscureText:
                              hidePassword || processing || !hasConnection,
                          enabled: !processing && hasConnection,
                          controller: reEnterPasswordController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            errorText: passwordError,
                            label: const Text("Retype Password"),
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

                      // Register Button
                      GestureDetector(
                        onTap: (passwordController.text.isNotEmpty &&
                                usernameController.text.isNotEmpty)
                            ? register
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
                                  'Register',
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
                          height: MediaQuery.of(context).size.height * 0.2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          GestureDetector(
                            onTap: (() {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          const LoginPage())));
                            }),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          )
                        ],
                      )
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

  // Register Function

  Future<void> register() async {
    bool? usernameValid;
    bool? passwordVerified;
    bool? registerSuccessful;

    passwordError = null;

    //set status to: processing data
    setState(() {
      usernameError = null;
      processing = true;
    });

    // Show loading Dialog
    showDialog(
      barrierDismissible: false,
      context: context,
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
          )),
    );

    // Check if username is valid
    final usernameResult = await verifyUsername(usernameController.text);
    if (usernameResult != "ERROR") {
      if (usernameResult == "0") {
        usernameError = null;
        usernameValid = true;
      } else {
        usernameValid = false;
        usernameError = "Username already exists.";
        registerSuccessful = false;
      }

      if (usernameValid) {
        // Check if the passwords match
        if (passwordController.text == reEnterPasswordController.text) {
          passwordVerified = true;
          setState(() {
            passwordError = null;
          });

          final registerUserResult = await registerUser(
              usernameController.text, passwordController.text);

          // Check if there was an error
          if (registerUserResult != "ERROR") {
            // Register User
            if (registerUserResult == "1") {
              registerSuccessful = true;
              passwordError = null;
            } else {
              registerSuccessful = false;
            }
          }
        } else {
          setState(() {
            passwordError = "Passwords do not match";
            passwordVerified = false;
            registerSuccessful = false;
          });
        }
      }
    }

    // Remove Dialog
    Navigator.of(context).pop();

    //set status to: not processing data
    setState(() {
      processing = false;
    });

    if (registerSuccessful != null &&
        usernameValid != null &&
        passwordVerified != null) {
      if (!registerSuccessful! && passwordVerified! && usernameValid) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("An error occoured. Try Again.")));
      }

      if (usernameValid && registerSuccessful!) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text("Register Successful! You can log into your account.")));
      }
    }
  }
}
