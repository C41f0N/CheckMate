import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EditTaskDialogue extends StatefulWidget {
  EditTaskDialogue(
      {super.key,
      required this.editTaskName,
      required this.checkTaskExistenceCallback,
      required this.oldTaskName});

  @override
  State<EditTaskDialogue> createState() => _EditTaskDialogueState();

  final String oldTaskName;
  final Function(String, String) editTaskName;
  final bool Function(String) checkTaskExistenceCallback;
  String? errorText;
  TextEditingController taskNameController = TextEditingController();
}

class _EditTaskDialogueState extends State<EditTaskDialogue> {

  
  @override
  void initState() {
    widget.taskNameController.text = widget.oldTaskName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      content: SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Edit Task",
              style: TextStyle(
                fontSize: 25,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              controller: widget.taskNameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                label: const Text("New task name"),
                // labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                errorText: widget.errorText,
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
                if (!widget
                    .checkTaskExistenceCallback(widget.taskNameController.text)) {
                  if (widget.taskNameController.text != '') {
                    if (!widget.taskNameController.text.contains("|")) {
                      widget.editTaskName(widget.oldTaskName, widget.taskNameController.text);
                      widget.errorText = null;
                      Navigator.pop(context);
                    } else {
                      setState(() {
                        widget.errorText = "Task name cannot contain '|'";
                      });
                    }
                  }
                } else {
                  setState(() {
                    widget.errorText = "Task Already Exists";
                  });
                }
              },
              child: const Text("Edit"),
            )
          ],
        ),
      ),
    );
    
  }
}
