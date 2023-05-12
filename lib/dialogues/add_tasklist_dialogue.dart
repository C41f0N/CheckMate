import 'package:flutter/material.dart';

class AddNewTaskListDialogue extends StatefulWidget {
  const AddNewTaskListDialogue({
    super.key,
    required this.addTaskListCallback,
    required this.taskLists,
  });

  @override
  State<AddNewTaskListDialogue> createState() => _AddNewTaskListDialogueState();

  final void Function(String) addTaskListCallback;
  final List<String> taskLists;
}

class _AddNewTaskListDialogueState extends State<AddNewTaskListDialogue> {
  String? errorText;
  TextEditingController taskListNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      content: SizedBox(
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Add Task List",
              style: TextStyle(
                fontSize: 30,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              keyboardType: TextInputType.name,
              controller: taskListNameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                label: const Text("New Task List"),
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
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                if (!widget.taskLists.contains(taskListNameController.text)) {
                  if (taskListNameController.text.length <= 18) {
                  if (taskListNameController.text != '') {
                    if (!taskListNameController.text.contains("|") &&
                        !taskListNameController.text.contains("^")) {
                      widget.addTaskListCallback(taskListNameController.text);
                      errorText = null;
                      Navigator.pop(context);
                    } else {
                      setState(() {
                        errorText = "Task List name cannot contain '|' or '^'";
                      });
                    }
                  }} else {
                    setState(() {
                      errorText = "Cannot be longer that 18 letters";
                    });
                  }
                } else {
                  setState(() {
                    errorText = "Task List Already Exists";
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
