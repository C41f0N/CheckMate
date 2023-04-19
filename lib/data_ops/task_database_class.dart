import 'package:hive_flutter/hive_flutter.dart';
import 'package:check_mate/data_ops/encryption.dart';
import 'package:check_mate/data_ops/task_data_from_cloud.dart';
import 'package:check_mate/data_ops/user_session_local_ops.dart';
import 'package:check_mate/task_data_classes/user_tasks_class.dart';

import '../task_data_classes/task_class.dart';

class TaskDatabase {
  UserTasksData tasksData = UserTasksData();
  final _myBox = Hive.box("TASKS_LOCAL_DATABASE");

  TaskDatabase() {
    if (getAllListNames().isNotEmpty) {
      setFocusedList(tasksData.getListNames()[0]);
    } else {
      createDefaultData();
    }
  }

  void createDefaultData() {
    tasksData.createDefaultData();
    setFocusedList(tasksData.getListNames()[0]);
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
  }

  void setFocusedList(String listName) {
    _myBox.put("FOCUSED_LIST", listName);
  }

  String getFocusedList() {
    String? focusedListName = _myBox.get("FOCUSED_LIST");

    // if focusedListName is null or invalid, return the first list in the user's database
    if (focusedListName == null ||
        !tasksData.getListNames().contains(focusedListName)) {
      setFocusedList(tasksData.getListNames()[0]);
      return tasksData.getListNames()[0];
    } else {
      // else return the value directly
      return focusedListName;
    }
  }

  void changeCompleteStatus(String taskName) {
    // Get the tasks list
    tasksData.toggleTaskCompletion(getFocusedList(), taskName);
    saveData();
  }

  void addTask(String taskName) {
    tasksData.addTaskToList(getFocusedList(), taskName);
    saveData();
  }

  void addTaskAtIndex(Task task, int index) {
    tasksData.addTaskToListAtIndex(getFocusedList(), task, index);
    saveData();
  }

  bool checkTaskExistence(String taskName) {
    loadData();

    return tasksData.checkTaskExistence(getFocusedList(), taskName);
  }

  void deleteTask(String taskName) {
    tasksData.deleteTask(getFocusedList(), taskName);
    saveData();
  }

  Task deleteTaskAtIndex(int index) {
    return tasksData.deleteTaskAtIndex(getFocusedList(), index);
  }

  void deleteCheckedTasks() {
    tasksData.deleteCheckedTasks(getFocusedList());
    saveData();
  }

  void editTaskName(String oldTaskName, String newTaskName) {
    tasksData.editTaskName(getFocusedList(), oldTaskName, newTaskName);
    saveData();
  }

  int getTaskIndex(String taskName) {
    return tasksData.getTaskIndex(getFocusedList(), taskName);
  }

  Task getTaskFromIndex(int index) {
    return tasksData.getTaskFromIndex(getFocusedList(), index);
  }

  List<Task> getTaskList() {
    loadData();
    return tasksData.getTaskList(getFocusedList());
  }

  List<String> getAllListNames() {
    loadData();
    return tasksData.getListNames();
  }

  void addNewList(String listName) {
    tasksData.addNewList(listName);
    saveData();
  }

  void deleteTaskList(String listName) {
    tasksData.deleteTaskList(listName);
    saveData();
  }

  void switchToAnotherTaskList(String listName) {
    if (tasksData.checkTaskListExistance(listName)) {
      setFocusedList(listName);
    }
  }

  String getCurrentListName() {
    loadData();
    return getFocusedList();
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
}
