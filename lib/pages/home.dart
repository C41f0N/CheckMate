import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sarims_todo_app/data_ops/task_database_class.dart';
import 'package:sarims_todo_app/pages/login.dart';
import 'package:sarims_todo_app/widgets/task_card.dart';
import '../data_ops/encryption.dart';
import '../data_ops/user_session_local_ops.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("T O D O   L I S T"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                reorderMode = !reorderMode;
              });
            },
            icon: reorderMode
                ? const Icon(Icons.check)
                : const Icon(Icons.reorder),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: ((context) => AlertDialog(
                      title: const Text(
                        "Are you sure you want to log out?",
                        style: TextStyle(color: Colors.white),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: logout,
                          child: const Text("Yes"),
                        ),
                        TextButton(
                          onPressed: (() => Navigator.pop(context)),
                          child: const Text("No"),
                        )
                      ],
                    )),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder(
          future: db.loadData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == true) {
                List<List> taskList = db.taskList;
                return reorderMode
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
                        onReorder: (int oldIndex, int newIndex) async {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          List removedtask =
                              await db.deleteTaskAtIndex(oldIndex);
                          db.addTaskAtIndex(removedtask, newIndex);
                          setState(() {});
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
                      );
              } else {
                return const Center(
                  child: Text(
                    "Could not connect, please refresh",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
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

  Future<void> onTaskCheckChange(String taskName, bool completed) async {
    await db.changeCompleteStatus(taskName);
    setState(() {});
  }

  Future<void> addTask(String taskName) async {
    await db.addTask(taskName);
    setState(() {});
  }

  Future<bool> checkTaskExistence(String taskName) async {
    return await db.checkTaskExistence(taskName);
  }

  Future<void> deleteTask(String taskName) async {
    int index = db.taskList.indexWhere(
      (element) => element[0] == taskName,
    );
    List deletedTask = db.taskList[index];
    await db.deleteTask(taskName);
    setState(() {});
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

  void logout() {
    removeLoginInfoFromDevice();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Logged Out.")));
  }
}
