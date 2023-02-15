import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';

import '../data_ops/cloud_connections.dart';

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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                          label: Text("Username"),
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
                        enabled: connection.data! && !processing,
                        controller: passwordController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          errorText: passwordError,
                          label: Text("Password"),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                        // ElevatedButton(
                        //     onPressed: connection.data! ? login : () {},
                        //     child: const Text('Login'),
                        //   )
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
                              children: [
                                const Icon(Icons
                                    .signal_wifi_connected_no_internet_4_rounded),
                                const Text(
                                  "No internet connection :(",
                                ),
                                const SizedBox(),
                              ],
                            ),
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

  Future<void> login() async {
    setState(() {
      processing = true;
    });
    showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              content: SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              ),
            )));
    if (await verifyUsername(usernameController.text)) {
      usernameError = null;
    } else {
      usernameError = "Username does not exist.";
    }
    Navigator.of(context).pop();
    setState(() {
      processing = false;
    });
  }
}
