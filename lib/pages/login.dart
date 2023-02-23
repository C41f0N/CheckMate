import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:sarims_todo_app/pages/register.dart';
import '../data_ops/user_session_cloud_ops.dart';
import '../data_ops/user_session_local_ops.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
                        height: MediaQuery.of(context).size.height * 0.28,
                      ),

                      // Login Title
                      Text(
                        "Login",
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
                          enabled: !processing && hasConnection,
                          controller: usernameController,
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
                        height: 20,
                      ),

                      // Login Button if connected, else warning message
                      GestureDetector(
                        onTap: (passwordController.text.isNotEmpty &&
                                usernameController.text.isNotEmpty)
                            ? login
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
                              ? const Text(
                                  'Login',
                                  style: TextStyle(color: Colors.white),
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
                          height: MediaQuery.of(context).size.height * 0.23),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "First time?",
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
                              Navigator.pushNamed(context, "/register");
                            }),
                            child: Text(
                              "Register",
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

  // Login Function

  Future<void> login() async {
    bool? usernameValid;
    bool? passwordValid;

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

    // Check if username is valid
    final usernameResult = await verifyUsername(usernameController.text);
    if (usernameResult != "ERROR") {
      if (usernameResult == "1") {
        usernameError = null;
        usernameValid = true;
      } else {
        usernameValid = false;
        usernameError = "Username does not exist.";
        passwordValid = false;
      }

      // If Username is Valid
      if (usernameValid) {
        // Verify Password
        final passwordResult = await verifyPassword(
            usernameController.text, passwordController.text);
        if (passwordResult != "ERROR") {
          if (passwordResult == "1") {
            passwordValid = true;
            passwordError = null;
          } else if (passwordResult == "0") {
            passwordValid = false;
            passwordError = "Incorrect Password";
          }
        }
      }
    }

    // Remove Dialog
    Navigator.of(context).pop();

    //set status to: not processing data
    setState(() {
      processing = false;
    });

    // If verification was successfully done, then do this
    if (usernameValid != null && passwordValid != null) {
      if (usernameValid && passwordValid) {
        saveLoginInfoToDevice(
          usernameController.text,
          passwordController.text,
        );

        Navigator.pop(context);
        Navigator.pushNamed(context, "/home");
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Login Successfull.")));
      }
      // Else show connection error
    } else {
      print("Trying to show connection error");
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
