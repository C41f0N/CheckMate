import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:sarims_todo_app/data_ops/task_database_class.dart';
import 'package:sarims_todo_app/widgets/no_internet_indicator.dart';
import 'package:sarims_todo_app/widgets/refreshing_data_indicator.dart';
import 'package:sarims_todo_app/widgets/task_card.dart';
import '../data_ops/user_session_local_ops.dart';
import '../dialogues/add_task_dialogue.dart';
import '../widgets/uploading_data_indicator.dart';

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
  bool isFirstUpdate = true;
  bool isUploading = false;
  bool isRefreshing = false;

  @override
  void initState() {
    if (_myBox.get("SERVER_UPDATE_NEEDED") == null) {
      _myBox.put("SERVER_UPDATE_NEEDED", false);
    }

    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!DateTime.now().isBefore(nextUpdateAt) && timer.isActive) {
        if (await checkServerUpdateAppointmentStatus()) {
          await uploadTaskData();
        } else {
          if (!isFirstUpdate) {
            await refreshTaskData();
          }
        }
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
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text("Sarim's To Do App"),
            ),
            ListTile(
              title: const Text("Change Theme"),
              onTap: () {},
            ),
            ListTile(
              title: const Text("Credits"),
              onTap: () {},
            ),
            ListTile(
              title: const Text("Change Password"),
              onTap: changePassword,
            ),
            ListTile(
              title: const Text("Logout"),
              onTap: logout,
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("T O - D O   L I S T"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              if (!isUploading && !isRefreshing) {
                setState(() {
                  reorderMode = !reorderMode;
                });
              }
            },
            icon: reorderMode
                ? const Icon(Icons.check)
                : const Icon(Icons.reorder),
          ),
          !(Platform.isAndroid || Platform.isIOS)
              ? IconButton(
                  onPressed: refreshList,
                  icon: const Icon(Icons.refresh),
                )
              : const SizedBox()
        ],
      ),
      body: StreamBuilder(
          stream: InternetConnectivity().observeInternetConnection,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              bool hasConnection = snapshot.data!;
              return Stack(
                alignment: AlignmentDirectional.topStart,
                children: [
                  FutureBuilder(
                      future: isFirstUpdate
                          ? db.getTaskDataFromServer()
                          : Future.sync(() => db.loadData()),
                      builder: (context, snapshot) {
                        isFirstUpdate = false;

                        var taskList = db.taskList;
                        List<Widget> taskDisplayList = [
                          SizedBox(
                            height:
                                isUploading || isRefreshing || !hasConnection
                                    ? 40
                                    : 0,
                          ),
                          ...taskList.map((taskData) {
                            return TaskCard(
                                taskName: taskData[0],
                                completed: taskData[1],
                                onTaskCheckChange: isRefreshing || isUploading
                                    ? () {}
                                    : onTaskCheckChange,
                                onDelete: isRefreshing || isUploading
                                    ? () {}
                                    : deleteTask,
                                reorderingMode: reorderMode);
                          }).toList()
                        ];

                        if (snapshot.hasData) {
                          return reorderMode
                              ? ReorderableListView.builder(
                                  header:
                                      SizedBox(height: hasConnection ? 0 : 40),
                                  // buildDefaultDragHandles: true,
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 6, 0, 0),
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
                              : RefreshIndicator(
                                  key: GlobalKey<RefreshIndicatorState>(),
                                  onRefresh: refreshList,
                                  child: ListView(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 6, 0, 0),
                                    clipBehavior: Clip.antiAlias,
                                    children: taskDisplayList,
                                  ),
                                );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      }),
                  hasConnection
                      ? isUploading
                          ? const UploadingDataIndicator()
                          : isRefreshing
                              ? const RefreshingDataIndicator()
                              : const SizedBox()
                      : const NoInternetIndicator(),
                ],
              );
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

  void onTaskCheckChange(String taskName, bool completed) {
    setState(() {
      db.changeCompleteStatus(taskName);
      setUpdateAppointmentWithServerStatus(true);
    });
  }

  void addTask(String taskName) {
    var taskAdded = false;
    while (!taskAdded) {
      if (!(isUploading || isRefreshing)) {
        db.addTask(taskName);
        taskAdded = true;
        setState(() {});
      }
      setUpdateAppointmentWithServerStatus(true);
    }
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
                                "Are you sure? There is still some data not yet written to the cloud, we advise refreshing the list first.",
                                style: TextStyle(color: Colors.white),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    removeLoginInfoFromDevice();
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil('/login',
                                            (Route<dynamic> route) => false);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text("Logged Out.")));
                                  },
                                  child: const Text("Yes"),
                                ),
                                TextButton(
                                  onPressed: (() => Navigator.pop(context)),
                                  child: const Text("No"),
                                ),
                              ],
                            )));
                  } else {
                    removeLoginInfoFromDevice();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login', (Route<dynamic> route) => false);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Logged Out.")));
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
  }

  Future<void> refreshList() async {
    nextUpdateAt = DateTime.now();
    return checkServerUpdateAppointmentStatus()
        ? await uploadTaskData()
        : await refreshTaskData();
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
    if (value) {
      nextUpdateAt = DateTime.now().add(const Duration(seconds: 10));
    }
    _myBox.put("SERVER_UPDATE_NEEDED", value);
  }

  bool checkServerUpdateAppointmentStatus() {
    final result = _myBox.get("SERVER_UPDATE_NEEDED");
    if (result != null) {
      return result;
    } else {
      return false;
    }
  }

  Future<void> uploadTaskData() async {
    setState(() {
      isUploading = true;
    });
    final uploadResult = await db.uploadDataToServer();
    if (uploadResult) {
      nextUpdateAt = DateTime.now().add(const Duration(seconds: 30));
      setUpdateAppointmentWithServerStatus(false);
    }
    setState(() {
      isUploading = false;
    });
  }

  Future<void> refreshTaskData() async {
    setState(() {
      isRefreshing = true;
    });
    final downloadResult = await db.getTaskDataFromServer();
    setState(() {
      isRefreshing = false;
    });
    if (downloadResult) {
      nextUpdateAt = DateTime.now().add(const Duration(seconds: 30));
      db.loadData();
    }
  }

  void changePassword() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/change_password', (Route<dynamic> route) => false);
  }
}
