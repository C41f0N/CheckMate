import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:sarims_todo_app/data_ops/task_database_class.dart';
import 'package:sarims_todo_app/dialogues/change_theme_dialogue.dart';
import 'package:sarims_todo_app/dialogues/credits.dart';
import 'package:sarims_todo_app/utils/ui_banners/you_have_no_tasks_banner.dart';
import 'package:sarims_todo_app/widgets/home_page_drawer.dart';
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
  bool userModifyingData = false;

  @override
  void initState() {
    if (_myBox.get("SERVER_UPDATE_NEEDED") == null) {
      _myBox.put("SERVER_UPDATE_NEEDED", false);
    }

    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      print("$userModifyingData ${DateTime.now()}");
      if (!DateTime.now().isBefore(nextUpdateAt) && timer.isActive) {
        if (checkServerUpdateAppointmentStatus() && !userModifyingData) {
          await uploadTaskData();
        } else {
          if (!isFirstUpdate && !userModifyingData) {
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
      drawer: HomePageDrawer(
        logoutMethod: logout,
        showChangeThemeMethod: showThemeChangeDialogue,
        changePasswordMethod: changePassword,
        showCreditsDialogMethod: showCreditsDialog,
        deleteCheckedTasksMethod: deleteCheckedTasks,
      ),
      appBar: AppBar(
        backgroundColor: reorderMode
            ? Theme.of(context).primaryColor.withAlpha(200)
            : Theme.of(context).primaryColor,
        title: !reorderMode
            ? const Text("T O - D O   L I S T")
            : const Text("R E O R D E R   M O D E"),
        centerTitle: true,
        actions: [
          !(Platform.isAndroid || Platform.isIOS) && !userModifyingData
              ? IconButton(
                  onPressed: refreshList,
                  icon: const Icon(Icons.refresh),
                )
              : const SizedBox(),
          IconButton(
            onPressed: () {
              if (!isUploading && !isRefreshing) {
                setState(() {
                  reorderMode = !reorderMode;
                  userModifyingData = reorderMode;
                });
              }
            },
            icon: reorderMode
                ? const Icon(Icons.check)
                : const Icon(Icons.reorder),
          ),
        ],
      ),
      body: StreamBuilder(
          // Checking internet availability
          stream: InternetConnectivity().observeInternetConnection,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              bool hasConnection = snapshot.data!;
              return Stack(
                alignment: AlignmentDirectional.topStart,
                children: [
                  FutureBuilder(
                      // Check if it is the first update, if it is,
                      // then load data from the servers instead of
                      // local storage
                      future: isFirstUpdate
                          ? db.getTaskDataFromServer()
                          : Future.sync(() => db.loadData()),
                      builder: (context, snapshot) {
                        isFirstUpdate = false;

                        var taskList = db.taskList;
                        // Add an empty space to the top of the list if
                        // a banner needss to be placed.
                        List<Widget> taskDisplayList = [
                          SizedBox(
                            height:
                                isUploading || isRefreshing || !hasConnection
                                    ? 40
                                    : 0,
                          ),
                          ...taskList.map((taskData) {
                            return TaskCard(
                              key: UniqueKey(),
                              taskName: taskData[0],
                              completed: taskData[1],
                              onTaskCheckChange: isRefreshing || isUploading
                                  ? (taskName, completed) {}
                                  : onTaskCheckChange,
                              onDelete: isRefreshing || isUploading
                                  ? (taskName) {}
                                  : deleteTask,
                              reorderingMode: reorderMode,
                              enabled: !(isUploading || isRefreshing),
                            );
                          }).toList()
                        ];

                        if (snapshot.hasData) {
                          return reorderMode
                              ? taskList.isNotEmpty
                                  ? ReorderableListView(
                                      header: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          SizedBox(
                                              height: !hasConnection ||
                                                      isRefreshing ||
                                                      isUploading
                                                  ? 40
                                                  : 0),
                                        ],
                                      ),
                                      // buildDefaultDragHandles: true,
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      onReorder: onReorder,
                                      children: taskDisplayList.sublist(1),
                                    )
                                  : taskList.isNotEmpty
                                      ? ListView(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 6, 0, 0),
                                          clipBehavior: Clip.antiAlias,
                                          children: taskDisplayList)
                                      : const YouHaveNoTasksBanner()
                              : RefreshIndicator(
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  key: GlobalKey<RefreshIndicatorState>(),
                                  onRefresh: refreshList,
                                  // Check if reorder mode is turned on
                                  child: taskList.isNotEmpty
                                      ? ListView(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 6, 0, 0),
                                          clipBehavior: Clip.antiAlias,
                                          children: taskDisplayList,
                                        )
                                      : const YouHaveNoTasksBanner(),
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
      floatingActionButton: !reorderMode
          ? FloatingActionButton(
              onPressed: showAddTaskDialogue,
              child: const Icon(Icons.add),
            )
          : const SizedBox(),
    );
  }

  void onTaskCheckChange(String taskName, bool completed) {
    setState(() {
      db.changeCompleteStatus(taskName);
      setUpdateAppointmentWithServerStatus(true);
    });
  }

  void addTask(String taskName) {
    db.addTask(taskName);
    userModifyingData = false;
    setState(() {});

    setUpdateAppointmentWithServerStatus(true);
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
    setUpdateAppointmentWithServerStatus(true);
    setState(() {});
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
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

  void showAddTaskDialogue() {
    setState(() {
      userModifyingData = true;
    });
    showDialog(
      context: context,
      builder: ((_) {
        return AddTaskDialogue(
          addTaskCallback: addTask,
          checkTaskExistenceCallback: checkTaskExistence,
        );
      }),
    ).then((value) {
      setState(() {
        userModifyingData = false;
      });
    });
  }

  Future<void> refreshList() async {
    if (!isUploading && !isRefreshing) {
      nextUpdateAt = DateTime.now();
      return checkServerUpdateAppointmentStatus()
          ? await uploadTaskData()
          : await refreshTaskData();
    }
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
      nextUpdateAt = DateTime.now().add(const Duration(seconds: 3));
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
    if (uploadResult == "1") {
      nextUpdateAt = DateTime.now().add(const Duration(seconds: 30));
      setUpdateAppointmentWithServerStatus(false);
    } else if (uploadResult == "password_changed") {
      onChangedPassword();
    }
    setState(() {
      isUploading = false;
    });
  }

  Future<void> refreshTaskData() async {
    setState(() {
      reorderMode = false;
      isRefreshing = true;
    });
    final downloadResult = await db.getTaskDataFromServer();
    setState(() {
      isRefreshing = false;
    });
    if (downloadResult == "1") {
      nextUpdateAt = DateTime.now().add(const Duration(seconds: 30));
      db.loadData();
    } else if (downloadResult == "password_changed") {
      onChangedPassword();
    }
  }

  onChangedPassword() {
    removeLoginInfoFromDevice();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Your password was changed, please log in again")));
  }

  void changePassword() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/change_password', (Route<dynamic> route) => false);
  }

  void showThemeChangeDialogue() {
    showDialog(
      context: context,
      builder: (context) => const ChangeThemeDialogue(),
    );
  }

  void showCreditsDialog() {
    showDialog(context: context, builder: ((context) => const Credits()));
  }

  void deleteCheckedTasks() {
    if (!isUploading && !isRefreshing) {setState(() {
      userModifyingData = true;
    });
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: const Text(
              "Remove all completed tasks?",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: (() {
                  db.deleteCheckedTasks();
                  setUpdateAppointmentWithServerStatus(true);
                  setState(() {});
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Removed completed tasks. ")));
                }),
                child: const Text("Yes"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("No"),
              )
            ],
          )),
    ).then((value) {
      setState(() {
        userModifyingData = false;
      });
    });
  }}
}
