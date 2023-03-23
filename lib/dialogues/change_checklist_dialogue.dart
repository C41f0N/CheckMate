import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../data_ops/task_database_class.dart';

class ChangeCheckListDialogue extends StatelessWidget {
  const ChangeCheckListDialogue({
    super.key,
    required this.listNames,
    required this.addNewTaskListMethod,
    required this.deleteTaskListMethod,
    required this.switchToTaskListMethod,
  });

  final List<String> listNames;
  final void Function(String) addNewTaskListMethod;
  final void Function(String) deleteTaskListMethod;
  final void Function(String) switchToTaskListMethod;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Check Lists",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 23,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 300,
            width: 200,
            child: ListView.builder(
              itemCount: listNames.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  title: Text(
                    listNames[index],
                    style: TextStyle(
                      color: Colors.grey[200],
                    ),
                  ),
                  onTap: () {
                    switchToTaskListMethod(listNames[index]);
                  },
                );
              }),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Container(
              alignment: Alignment.center,
              height: 50,
              width: 180,
              child: Text("Add New"),
            ),
          ),
        ],
      ),
    );
  }
}
