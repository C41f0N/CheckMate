import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sarims_todo_app/data_ops/task_database_class.dart';
import 'package:sarims_todo_app/widgets/task_card.dart';
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
  DateTime nextUpdateAt = DateTime.now().add(const Duration(seconds: 5));
  Timer? timer;
  bool? serverNeedstoBeUpdated;
  bool localDataNeedsToBeUpdated = true;
  int serverCount = 0;

  @override
  void initState() {
    fetchDataFromServer();

    if (_myBox.get("SERVER_UPDATE_NEEDED") == null) {
      _myBox.put("SERVER_UPDATE_NEEDED", false);
    }

    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final appointmentStatus = _myBox.get("SERVER_UPDATE_NEEDED") ?? false;
      print("Appointment with server => $appointmentStatus");
      if (timer.isActive &&
          (DateTime.now().isAfter(nextUpdateAt) ||
              DateTime.now().isAtSameMomentAs(nextUpdateAt))) {
        print(serverCount);
        serverCount++;
        if (appointmentStatus) {
          // if there has been new changes then upload data
          print("Uploading Data");
          if (await db.uploadDataToServer()) {
            setUpdateAppointmentWithServerStatus(false);
          }
        } else {
          print("Fetching data");
          // else download data and update it
          if (!localDataNeedsToBeUpdated) {
            await db.getTaskDataFromServer();
            setState(() {});
          }
        }

        nextUpdateAt = DateTime.now().add(const Duration(seconds: 5));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  bool reorderMode = false;

  @override
  Widget build(BuildContext context) {
    if (localDataNeedsToBeUpdated) {
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
                            onPressed: () {
                              if (checkServerUpdateAppointmentStatus()) {
                                Navigator.of(context).pop();
                                showDialog(
                                    context: context,
                                    builder: ((context) => AlertDialog(
                                          title: const Text(
                                            "Are you sure? There is still some data not yet written to the cloud, we advise waiting some seconds.",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: logout,
                                              child: const Text("Yes"),
                                            ),
                                            TextButton(
                                              onPressed: (() =>
                                                  Navigator.pop(context)),
                                              child: const Text("No"),
                                            ),
                                          ],
                                        )));
                              } else {
                                logout();
                              }
                            },
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
            future: db.getTaskDataFromServer(),
            builder: (context, snapshot) {
              localDataNeedsToBeUpdated = false;

              var taskList = db.taskList;
              List<Widget> taskDisplayList = taskList.map((taskData) {
                return TaskCard(
                    taskName: taskData[0],
                    completed: taskData[1],
                    onTaskCheckChange: onTaskCheckChange,
                    onDelete: deleteTask,
                    reorderingMode: reorderMode);
              }).toList();

              if (snapshot.hasData) {
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
                        onReorder: onReorder,
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                        clipBehavior: Clip.antiAlias,
                        children: taskDisplayList,
                      );
              } else {
                return Center(child: CircularProgressIndicator());
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
    } else {
      db.loadData();
      var taskList = db.taskList;
      List<Widget> taskDisplayList = taskList.map((taskData) {
        return TaskCard(
            taskName: taskData[0],
            completed: taskData[1],
            onTaskCheckChange: onTaskCheckChange,
            onDelete: deleteTask,
            reorderingMode: reorderMode);
      }).toList();

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
                            onPressed: () {
                              if (checkServerUpdateAppointmentStatus()) {
                                Navigator.of(context).pop();
                                showDialog(
                                    context: context,
                                    builder: ((context) => AlertDialog(
                                          title: const Text(
                                            "Are you sure? There is still some data not yet written to the cloud, we advise waiting some seconds.",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: logout,
                                              child: const Text("Yes"),
                                            ),
                                            TextButton(
                                              onPressed: (() =>
                                                  Navigator.pop(context)),
                                              child: const Text("No"),
                                            ),
                                          ],
                                        )));
                              } else {
                                logout();
                              }
                            },
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
                onReorder: onReorder,
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                clipBehavior: Clip.antiAlias,
                children: taskDisplayList,
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
  }

  void onTaskCheckChange(String taskName, bool completed) {
    setState(() {
      db.changeCompleteStatus(taskName);
      setUpdateAppointmentWithServerStatus(true);
    });
  }

  void addTask(String taskName) {
    setState(() {
      db.addTask(taskName);
      setUpdateAppointmentWithServerStatus(true);
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
    db.deleteTask(taskName);
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
                  setUpdateAppointmentWithServerStatus(true);
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

  void onReorder(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    List removedtask = db.deleteTaskAtIndex(oldIndex);
    db.addTaskAtIndex(removedtask, newIndex);
    setUpdateAppointmentWithServerStatus(true);
    setState(() {});
  }

  void setUpdateAppointmentWithServerStatus(bool value) {
    nextUpdateAt = DateTime.now().add(const Duration(seconds: 5));
    _myBox.put("SERVER_UPDATE_NEEDED", value);
  }

  bool checkServerUpdateAppointmentStatus() {
    final result =_myBox.get("SERVER_UPDATE_NEEDED");
    if (result != null) {
      return result;
    } else {
      return false;
    }
  }

  Future<void> fetchDataFromServer() async {
    await db.getTaskDataFromServer();
  }
}
