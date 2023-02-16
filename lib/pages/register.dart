import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:sarims_todo_app/pages/home.dart';

import '../data_ops/cloud_connections.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? usernameError;
  String? passwordError;
  bool processing = false;
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: InternetConnectivity().observeInternetConnection,
        builder: (context, connection) {
          if (connection.hasData) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(height: MediaQuery.of(context).size.height * 0.28,),
                    
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
                        enabled: connection.data! && !processing,
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
                            hidePassword || processing || !connection.data!,
                        enabled: connection.data! && !processing,
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
                    connection.data!
                        ? GestureDetector(
                            onTap: processing ? () {} : login,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              alignment: Alignment.center,
                              height: 55,
                              width:
                                  MediaQuery.of(context).size.width * 0.8 > 320
                                      ? 320
                                      : MediaQuery.of(context).size.width * 0.8,
                              child: const Text(
                                'Login',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.redAccent[700]!.withAlpha(230),
                            ),
                            alignment: Alignment.center,
                            height: 55,
                            width: MediaQuery.of(context).size.width * 0.8 > 320
                                ? 320
                                : MediaQuery.of(context).size.width * 0.8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Icon(Icons
                                    .signal_wifi_connected_no_internet_4_rounded),
                                Text(
                                  "No internet connection :(",
                                ),
                                SizedBox(),
                              ],
                            ),
                          ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.23),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already Have an account?",
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                        SizedBox(width: 4,),
                        GestureDetector(
                          onTap: (() {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: ((context) => const LoginPage())));
                          }),
                          child: Text("Signup", style: TextStyle(color: Theme.of(context).colorScheme.primary),),
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
        });
  }

  // Login Function

  Future<void> login() async {
    bool username_valid = false;
    bool password_valid = false;

    //set status to: processing data
    setState(() {
      processing = true;
    });

    // Show loading Dialog
    showDialog(
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
            )));

    // Check if username is valid
    if (await verifyUsername(usernameController.text)) {
      usernameError = null;
      username_valid = true;
    } else {
      username_valid = false;
      usernameError = "Username does not exist.";
    }

    if (username_valid) {
      // Verify Password
      if (await verifyPassword(
          usernameController.text, passwordController.text)) {
        password_valid = true;
        passwordError = null;
      } else {
        password_valid = false;
        passwordError = "Incorrect Password";
      }
      ;
    }

    // Remove Dialog
    Navigator.of(context).pop();

    //set status to: not processing data
    setState(() {
      processing = false;
    });

    if (username_valid && password_valid) {
      print("Verification Successfull.");
      // Navigator.pop(context);
      // Navigator.push(
      //     context, MaterialPageRoute(builder: ((context) => const HomePage())));
    }
  }
}
