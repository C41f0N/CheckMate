import 'package:flutter/material.dart';
import 'package:sarims_todo_app/config.dart';

class UsageExplainerMinimalDialogue extends StatelessWidget {
  const UsageExplainerMinimalDialogue({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: const EdgeInsets.all(16),
      title: Text(
        "Hello there!",
        style: TextStyle(
          color: Colors.grey[200],
          fontWeight: FontWeight.w600,
          fontSize: 25,
        ),
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        height: 230,
        width: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  style: TextStyle(
                    color: Colors.grey[300],
                    // fontWeight: FontWeight.w300,
                    fontSize: 17,
                  ),
                  children: <TextSpan>[
                    const TextSpan(
                      text: "Here is a useful tip,\nYou can swipe ",
                    ),
                    const TextSpan(
                        text: "right",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const TextSpan(text: " or "),
                    const TextSpan(
                        text: "left ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const TextSpan(text: "on your tasks to either "),
                    TextSpan(
                        text: "delete ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red[700])),
                    const TextSpan(text: "or "),
                    TextSpan(
                        text: "edit ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow[700])),
                    const TextSpan(text: "them.\n\n"),
                    const TextSpan(
                        text: "Note: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const TextSpan(
                        text:
                            "To get more options like customization, tap on the drawer button at the top left.")
                  ]),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Thanks, got it!",
                style: TextStyle(
                  color: currentTheme.isDark()
                      ? Colors.grey[900]
                      : Colors.grey[100],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
