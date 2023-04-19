import 'package:check_mate/task_data_classes/task_class.dart';

class TaskList {
  List<Task> tasksList;
  String listName;

  TaskList(this.listName, this.tasksList);

  addTask(String taskName) {
    tasksList.add(Task(taskName, false));
  }

  addTaskAtIndex(task, int index) {
    tasksList.insert(index, task);  
  }

  bool checkTaskExistence(String taskName) {
    return tasksList.indexWhere((Task task) => task.taskName == taskName) != -1;
  }

  deleteTask(taskName) {
    tasksList.removeWhere((Task task) => task.taskName == taskName);
  }

  Task deleteTaskAtIndex(index) {
    return tasksList.removeAt(index);
  }

  deleteCheckedTasks() {
    tasksList.removeWhere((Task task) => task.checked == true);
  }
  
  void editTaskName(String oldTaskName, String newTaskName) {
    int taskIndex =
        tasksList.indexWhere((Task task) => task.taskName == oldTaskName);
    Task oldTask = tasksList[taskIndex];
    oldTask.taskName = newTaskName;
    tasksList[taskIndex] = oldTask;
  }

  int getTaskIndex(String taskName) {
    return tasksList.indexWhere((Task task) => task.taskName == taskName);
  }

  Task getTaskFromIndex(int index) {
    return tasksList[index];
  }
}
