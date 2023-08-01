import 'package:flutter/material.dart';

class ErrorDialogue extends StatelessWidget {
  const ErrorDialogue({
    super.key,
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: SizedBox(
        width: MediaQuery.of(context).size.width * 0.2,
        child: Row(
          children: [
            Icon(
              Icons.error,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              "ERROR",
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
      content: Text(errorMessage),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Okay"),
          ),
        )
      ],
    );
  }
}
