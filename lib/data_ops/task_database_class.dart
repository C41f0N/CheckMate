class TaskDatabase {
  List<List> taskList = [];

  void createDefaultData() {
    taskList = [
      ["Clean Car", true],
      ["Kill Sarim", false],
      ["Hide Body", false],
      ["File Missing Person's Report", false],
    ];
  }

  void changeCompleteStatus(String taskName) {
    int index = taskList.indexWhere((taskData) => taskData[0] == taskName);
    taskList[index][1] = !taskList[index][1];
  }

  void addTask(String taskName) {
    taskList.add([taskName, false]);
  }

  void addTaskAtIndex(List task, int index) {
    taskList.insert(index, task);
  }

  bool checkTaskExistence(String taskName){
    int index = taskList.indexWhere((element) => element[0] == taskName);
    return index != -1; 
  }

  void deleteTask(String taskName) {
    taskList.removeWhere((element) => element[0] == taskName);
  }

  List deleteTaskAtIndex(int index) {
    return taskList.removeAt(index);
  }
}
