import 'package:hive_flutter/hive_flutter.dart';
import 'package:sarims_todo_app/data_ops/encryption.dart';
import 'package:sarims_todo_app/data_ops/task_data_from_cloud.dart';
import 'package:sarims_todo_app/data_ops/user_session_local_ops.dart';
import 'package:sarims_todo_app/task_data_classes/user_tasks_class.dart';

import '../task_data_classes/task_class.dart';

class TaskDatabase {
  UserTasksData tasksData = UserTasksData();
  String? focusedTaskListName;
  final _myBox = Hive.box("TASKS_LOCAL_DATABASE");

  void createDefaultData() {
    focusedTaskListName = "Main Tasks";
    tasksData.createDefaultData();
  }

  bool loadData() {
    if (_myBox.get("USER_TASKS_DATA") == null) {
      // Create defaults and save
      createDefaultData();
      saveData();
    } else {
      // fetch data from Hive
      String combinedStringData = _myBox.get('USER_TASKS_DATA');

      // parse the data
      tasksData.parseFromString(combinedStringData);
    }
    return true;
  }

  void saveData() {
    _myBox.put("USER_TASKS_DATA", tasksData.asString());
    // uploadDataToServer();
  }

  void changeCompleteStatus(String taskName) {
    // Get the tasks list
    tasksData.toggleTaskCompletion(focusedTaskListName!, taskName);
    saveData();
  }

  void addTask(String taskName) {
    tasksData.addTaskToList(focusedTaskListName!, taskName);
    saveData();
  }

  void addTaskAtIndex(Task task, int index) {
    tasksData.addTaskToListAtIndex(focusedTaskListName!, task, index);
    saveData();
  }

  bool checkTaskExistence(String taskName) {
    loadData();
    return tasksData.checkTaskExistence(focusedTaskListName!, taskName);
  }

  void deleteTask(String taskName) {
    tasksData.deleteTask(focusedTaskListName!, taskName);
    saveData();
  }

  Task deleteTaskAtIndex(int index) {
    return tasksData.deleteTaskAtIndex(focusedTaskListName!, index);
  }

  Future<String> uploadDataToServer() async {
    String taskDataString = tasksData.asString();

    if (getSessionEncryptionKey().isNotEmpty) {
      taskDataString = taskDataString.isEmpty ? "NO_DATA" : taskDataString;
      final encryptedData =
          encryptTaskData(taskDataString, getSessionEncryptionKey());
      final uploadResult = await uploadEncryptedDataToServer(encryptedData);
      return uploadResult != "auth_failed" ? uploadResult : "password_changed";
    } else {
      return "0";
    }
  }

  Future<String> getTaskDataFromServer() async {
    // Get Data
    final encryptedData = await fetchEncryptedDataFromServer();
    if (encryptedData == "auth_failed") {
      return "password_changed";
    } else if (encryptedData.isNotEmpty &&
        getSessionEncryptionKey().isNotEmpty) {
      if (encryptedData != "NULL") {
        // Decrypt Data
        final decryptedData =
            decryptTaskData(encryptedData, getSessionEncryptionKey());
        // Check if Decrypted Data has no tasks
        if (extractTaskData(decryptedData) == "NO_DATA") {
          tasksData.parseFromString("");
          saveData();
          return '1';
        } else

        // Verify Decrypted Data
        {
          if (verifyDecryptedData(decryptedData)) {
            tasksData.parseFromString(extractTaskData(decryptedData));
            saveData();
            return "1";
          } else {
            return "0";
          }
        }
      } else {
        loadData();
        // return await uploadDataToServer();
        return "1";
      }
    } else {
      return "0";
    }
  }

  void deleteCheckedTasks() {
    tasksData.deleteCheckedTasks(focusedTaskListName!);
    saveData();
  }

  void editTaskName(String oldTaskName, String newTaskName) {
   tasksData.editTaskName(focusedTaskListName!, oldTaskName, newTaskName);
   saveData();
  }
  
  int getTaskIndex(String taskName) {
    return tasksData.getTaskIndex(focusedTaskListName!, taskName);
  }
  
  Task getTaskFromIndex(int index) {
    return tasksData.getTaskFromIndex(focusedTaskListName!, index);
  }

  List<Task> getTaskList() {
    return tasksData.getTaskList(focusedTaskListName!);
  }
}
