import 'package:flutter/material.dart';

import 'add_tasklist_dialogue.dart';

class ChangeCheckListDialogue extends StatefulWidget {
  const ChangeCheckListDialogue({
    super.key,
    required this.addNewTaskListMethod,
    required this.deleteTaskListMethod,
    required this.switchToTaskListMethod,
    required this.getAllListNameMethod,
    required this.getFocusedListNameMethod,
  });

  final List<String> Function() getAllListNameMethod;
  final String Function() getFocusedListNameMethod;
  final void Function(String) addNewTaskListMethod;
  final void Function(String) deleteTaskListMethod;
  final void Function(String) switchToTaskListMethod;

  @override
  State<ChangeCheckListDialogue> createState() =>
      _ChangeCheckListDialogueState();
}

class _ChangeCheckListDialogueState extends State<ChangeCheckListDialogue> {
  @override
  Widget build(BuildContext context) {
    List<String> listNames = widget.getAllListNameMethod();
    String focusedList = widget.getFocusedListNameMethod();

    return AlertDialog(
      title: Text(
        "Check Lists",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 30,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 300,
            width: 220,
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                itemCount: listNames.length,
                itemBuilder: ((context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.switchToTaskListMethod(listNames[index]);
                      });
                    },
                    child: Container(
                      color: focusedList == listNames[index]
                          ? Colors.grey[800]
                          : Colors.transparent,
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            color: focusedList == listNames[index]
                                ? Theme.of(context).primaryColor
                                : Colors.transparent,
                            width: 4,
                            height: MediaQuery.of(context).size.height,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              listNames[index],
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.grey[200],
                              ),
                            ),
                          ),
                          focusedList != listNames[index]
                              ? IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.grey[200],
                                    size: 20,
                                  ),
                                  splashRadius: 20,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(
                                          "Are you sure you want to delete the list, '${listNames[index]}'?",
                                          style: TextStyle(
                                            color: Colors.grey[200],
                                          ),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                widget.deleteTaskListMethod(
                                                    listNames[index]);
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Yes"),
                                          ),
                                          TextButton(
                                            onPressed: (() {
                                              Navigator.pop(context);
                                            }),
                                            child: const Text("No"),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: ((context) => AddNewTaskListDialogue(
                      addTaskListCallback: widget.addNewTaskListMethod,
                      taskLists: listNames,
                    )),
              ).then((value) => {setState(() {})});
            },
            child: Container(
              alignment: Alignment.center,
              height: 50,
              width: 180,
              child: const Text("Add New"),
            ),
          ),
        ],
      ),
    );
  }
}
