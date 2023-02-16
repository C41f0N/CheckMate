import 'package:hive_flutter/hive_flutter.dart';
import 'package:sarims_todo_app/data_ops/encryption.dart';
import 'package:http/http.dart' as http;

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

  void loadData() {
    if (_myBox.get("TASKS_LIST") == null) {
      createDefaultData();
      saveData();
    } else {
      List<String> combinedStringList = _myBox.get('TASKS_LIST');
      taskList = [];
      for (var element in combinedStringList) {
        List<dynamic> taskData = element.split("||");
        String taskName = taskData[0];
        bool completed = taskData[1] == "true";
        taskList.add([taskName, completed]);
      }
    }
  }

  void saveData() {
    List<String> combinedStringList = [];
    for (var taskData in taskList) {
      List newTaskData = [taskData[0], ""];
      newTaskData[1] = taskData[1] ? "true" : "false";
      combinedStringList.add(newTaskData.join("||"));
    }

    _myBox.put("TASKS_LIST", combinedStringList);
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

  Future<void> uploadToServer() async {
    var combinedStringList = [];

    for (var element in taskList) {
      element[1] = element[1] ? "true" : "false";
      combinedStringList.add(element.join("||"));
    }

    String taskDataString = combinedStringList.join("|||");
    final encryptionPass = await generate32CharEncryptionCode('monpss');
    final encryptedData =  encryptTaskData(taskDataString, encryptionPass);
    
    await http.get(Uri.parse('https://sarimahmed.tech/sarim-s_todo_app/upload_task_data.php?username=sarim&hash=anewhash&task_data=${Uri.encodeComponent(encryptedData)}'));
    
    var result = await http.get(Uri.parse('https://sarimahmed.tech/sarim-s_todo_app/get_task_data.php?username=sarim&hash=anewhash'));
    
  }
}
