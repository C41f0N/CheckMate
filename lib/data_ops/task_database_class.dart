import 'package:hive_flutter/hive_flutter.dart';
import 'package:sarims_todo_app/data_ops/encryption.dart';
import 'package:sarims_todo_app/data_ops/task_data_from_cloud.dart';
import 'package:sarims_todo_app/data_ops/user_session_local_ops.dart';

class TaskDatabase {
  List<List<dynamic>> taskList = [];
  final _myBox = Hive.box("TASKS_LOCAL_DATABASE");

  void createDefaultData() {
    taskList = [
      ["Clean Car", true],
      ["Kill Sarim", false],
      ["Hide Body", false],
      ["File Missing Person's Report", false],
    ];
  }

  bool loadData() {
    if (_myBox.get("TASKS_LIST") == null) {
      // Create defaults and save
      createDefaultData();
      saveData();
    } else {
      // fetch data from server
      List<String> combinedStringList = _myBox.get('TASKS_LIST');
      taskList = [];
      for (var element in combinedStringList) {
        List<dynamic> taskData = element.split("||");
        String taskName = taskData[0];
        bool completed = taskData[1] == "true";
        taskList.add([taskName, completed]);
      }
    }
    return true;
  }

  void saveData() {
    List<String> combinedStringList = [];
    for (var taskData in taskList) {
      List newTaskData = [taskData[0], ""];
      newTaskData[1] = taskData[1] ? "true" : "false";
      combinedStringList.add(newTaskData.join("||"));
    }

    _myBox.put("TASKS_LIST", combinedStringList);
    // uploadDataToServer();
  }

  void changeCompleteStatus(String taskName) {
    int index = taskList.indexWhere((taskData) => taskData[0] == taskName);
    taskList[index][1] = !taskList[index][1];
    saveData();
  }

  void addTask(String taskName) {
    taskList.insert(0, [taskName, false]);
    saveData();
  }

  void addTaskAtIndex(List task, int index) {
    taskList.insert(index, task);
    saveData();
  }

  bool checkTaskExistence(String taskName) {
    loadData();
    int index = taskList.indexWhere((element) => element[0] == taskName);
    return index != -1;
  }

  void deleteTask(String taskName) {
    taskList.removeWhere((element) => element[0] == taskName);
    saveData();
  }

  List deleteTaskAtIndex(int index) {
    saveData();
    return taskList.removeAt(index);
  }

  Future<String> uploadDataToServer() async {
    List<String> combinedStringList = [];

    for (var taskData in taskList) {
      List newTaskData = [taskData[0], ""];
      newTaskData[1] = taskData[1] ? "true" : "false";
      combinedStringList.add(newTaskData.join("||"));
    }

    String taskDataString = combinedStringList.join("|||");
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
          taskList = [];
          saveData();
          return '1';
        } else
        // Verify Decrypted Data
        {
          if (verifyDecryptedData(decryptedData)) {
            // print(decryptedData);
            var combinedStringTaskData =
                extractTaskData(decryptedData).split("|||");
            taskList = [];

            for (var element in combinedStringTaskData) {
              List<dynamic> taskData = element.split("||");

              String taskName = taskData[0];
              bool completed = taskData[1] == "true";
              taskList.add([taskName, completed]);
            }
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
    taskList.removeWhere((taskData) => taskData[1] == true);
    saveData();
  }

  void editTaskName(String oldTaskName, String newTaskName) {
    var taskIndex = taskList.indexWhere((taskData) => taskData[0] == oldTaskName);
    var oldTaskData = taskList[taskIndex];
    oldTaskData[0] = newTaskName;
    taskList[taskIndex] = oldTaskData;
    saveData();
  }
}
