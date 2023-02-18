import 'package:flutter/material.dart';

class AddTaskDialogue extends StatefulWidget {
  const AddTaskDialogue({
    super.key,
    required this.addTaskCallback,
    required this.checkTaskExistenceCallback,
  });
  @override
  State<AddTaskDialogue> createState() => _AddTaskDialogueState();

  final void Function(String) addTaskCallback;
  final bool Function(String) checkTaskExistenceCallback;
}

class _AddTaskDialogueState extends State<AddTaskDialogue> {
  String? errorText;
  TextEditingController taskNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Add Task",
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        height: 130,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: taskNameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                label: Text("New Task"),
                // labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                errorText: errorText,
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 3),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!widget
                    .checkTaskExistenceCallback(taskNameController.text)) {
                  if (taskNameController.text != '') {
                    widget.addTaskCallback(taskNameController.text);
                    Navigator.pop(context);
                  }
                  errorText = null;
                } else {
                  setState(() {
                    errorText = "Task Already Exists";
                  });
                }
              },
              child: const Text("Add"),
            )
          ],
        ),
      ),
    );
  }
}
