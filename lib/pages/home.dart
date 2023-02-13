import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sarims_todo_app/data_ops/task_database_class.dart';
import 'package:sarims_todo_app/widgets/task_card.dart';
import '../dialogues/add_task_dialogue.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  TaskDatabase db = TaskDatabase();
  final _myBox = Hive.box("TASKS_LOCAL_DATABASE");

  @override
  void initState() {

    if (_myBox.get("TASKS_LIST") == null) {
      db.createDefaultData();
    }
    super.initState();
  }

  bool reorderMode = false;

  @override
  Widget build(BuildContext context) {
    db.loadData();
    List<List> taskList = db.taskList;

    return Scaffold(
      appBar: AppBar(
        title: const Text("T O D O   L I S T"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  // reorderMode = !reorderMode;
                  db.uploadToServer();
                });
              },
              icon: reorderMode
                  ? const Icon(Icons.check)
                  : const Icon(Icons.reorder))
        ],
      ),
      body: reorderMode
          ? ReorderableListView.builder(
              padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
              itemCount: taskList.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  key: UniqueKey(),
                  taskName: taskList[index][0],
                  completed: taskList[index][1],
                  onTaskCheckChange: onTaskCheckChange,
                  onDelete: deleteTask,
                  reorderingMode: reorderMode,
                );
              },
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }

                  List removedtask = db.deleteTaskAtIndex(oldIndex);
                  db.addTaskAtIndex(removedtask, newIndex);
                });
              },
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
              clipBehavior: Clip.antiAlias,
              itemCount: taskList.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  key: UniqueKey(),
                  taskName: taskList[index][0],
                  completed: taskList[index][1],
                  onTaskCheckChange: onTaskCheckChange,
                  onDelete: deleteTask,
                  reorderingMode: reorderMode,
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: ((_) {
              return AddTaskDialogue(
                addTaskCallback: addTask,
                checkTaskExistenceCallback: checkTaskExistence,
              );
            }),
          );
        },
      ),
    );
  }

  void onTaskCheckChange(String taskName, bool completed) {
    setState(() {
      db.changeCompleteStatus(taskName);
    });
  }

  void addTask(String taskName) {
    setState(() {
      db.addTask(taskName);
    });
  }

  bool checkTaskExistence(String taskName) {
    return db.checkTaskExistence(taskName);
  }

  void deleteTask(String taskName) {
    int index = db.taskList.indexWhere(
      (element) => element[0] == taskName,
    );
    List deletedTask = db.taskList[index];
    setState(() {
      db.deleteTask(taskName);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Deleted Task"),
            TextButton(
              onPressed: () {
                setState(() {
                  db.addTaskAtIndex(deletedTask, index);
                });
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              child: const Text("Undo"),
            )
          ],
        ),
      ),
    );
  }
}
