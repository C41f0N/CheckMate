import 'package:sarims_todo_app/task_data_classes/task_class.dart';
import 'package:sarims_todo_app/task_data_classes/task_list_class.dart';

class UserTasksData {
  List<TaskList> taskLists = [];

  // To create default data
  createDefaultData() {
    taskLists = [
      TaskList("Main Tasks", [
        Task("Feed Dog", false),
        Task("Make Bed", false),
        Task("Work on world domination plan", true),
      ])
    ];
  }

  // Toggle task completion
  toggleTaskCompletion(String taskListName, String taskName) {
    taskLists
        .firstWhere((taskListData) => taskListData.listName == taskListName)
        .tasksList
        .firstWhere((task) => task.taskName == taskName)
        .toggleCompletion();
  }

  // Add new task to a list
  addTaskToList(String taskListName, String taskName) {
    taskLists
        .firstWhere((taskListData) => taskListData.listName == taskListName)
        .addTask(taskName);
  }

  // Insert a task object at a specific index
  addTaskToListAtIndex(String taskListName, Task task, int index) {
    taskLists
        .firstWhere((taskListData) => taskListData.listName == taskListName)
        .addTaskAtIndex(task, index);
  }

  // Check if a task exists
  bool checkTaskExistence(String taskListName, String taskName) {
    return taskLists
        .firstWhere((taskListData) => taskListData.listName == taskListName)
        .checkTaskExistence(taskName);
  }

  // Delete a task by name
  deleteTask(String taskListName, String taskName) {
    taskLists
        .firstWhere((taskListData) => taskListData.listName == taskListName)
        .deleteTask(taskName);
  }

  // Delete task at specific index
  Task deleteTaskAtIndex(String taskListName, int index) {
    return taskLists
        .firstWhere((taskListData) => taskListData.listName == taskListName)
        .deleteTaskAtIndex(index);
  }

  // Edit a task's name
  editTaskName(String taskListName, String oldTaskName, String newTaskName) {
    taskLists
        .firstWhere((taskListData) => taskListData.listName == taskListName)
        .editTaskName(oldTaskName, newTaskName);
  }

  // Get index of a task in a list
  getTaskIndex(String taskListName, String taskName) {
    taskLists
        .firstWhere((taskListData) => taskListData.listName == taskListName)
        .getTaskIndex(taskName);
  }

  // get Task object from its index
  Task getTaskFromIndex(String taskListName, int index) {
    return taskLists
        .firstWhere((taskListData) => taskListData.listName == taskListName)
        .getTaskFromIndex(index);
  }

  List<Task> getTaskList(String taskListName) {
    if (checkTaskListExistance(taskListName)) {
      return taskLists
          .firstWhere(
            (TaskList taskListData) => taskListData.listName == taskListName,
          )
          .tasksList;
    } else {
      return [];
    }
  }

  // Get All List Names
  List<String> getListNames() {
    List<String> listNames = [];
    for (TaskList taskListData in taskLists) {
      listNames.add(taskListData.listName);
    }
    return listNames;
  }

  // Add new taskList to UserData
  addNewList(String listName) {
    if (!checkTaskListExistance(listName)) {
      TaskList newListDataObj = TaskList(listName, []);
      taskLists.add(newListDataObj);
    }
  }

  // Delete a taskList from UserData
  deleteTaskList(String listName) {
    if (taskLists.length > 1) {
      taskLists.removeWhere(
          (TaskList taskListData) => taskListData.listName == listName);
    }
  }

  // Check if a task list exists
  bool checkTaskListExistance(String taskListName) {
    return taskLists.indexWhere(
            (TaskList taskListData) => taskListData.listName == taskListName) !=
        -1;
  }

  // Delete all checked tasks
  deleteCheckedTasks(String taskListName) {
    taskLists
        .firstWhere((taskListData) => taskListData.listName == taskListName)
        .deleteCheckedTasks();
  }

  // To generate a UserTask instance from previously parsed data
  parseFromString(String stringUserData) {
    if (stringUserData.isNotEmpty) {
      // empty previously held data
      taskLists = [];

      // Split String into individual taskListData
      List<String> allTaskListDataInString = stringUserData.split("^||||^");

      // For each taskListData
      for (String taskListDataInString in allTaskListDataInString) {
        // Split each taskListData into taskListName and tasksList(in String form / non parsed)
        String taskListName = taskListDataInString.split("^|||^")[0];
        List<String> taskListInString =
            taskListDataInString.split("^|||^")[1].split("^||^");

        // Parse tasksList into a List<Task>

        List<Task> tasksList = [];
        if (taskListInString.isNotEmpty && taskListInString[0].isNotEmpty) {
          tasksList = taskListInString.map((String taskDataInString) {
            String taskName = taskDataInString.split("^|^")[0];
            bool checked = taskDataInString.split("^|^")[1] == "true";

            return Task(taskName, checked);
          }).toList();
        }

        // Create a TaskList instance from parsed data
        TaskList parsedTaskList = TaskList(taskListName, tasksList);

        // add TaskList to the taskLists array
        taskLists.add(parsedTaskList);
      }
    } else {
      taskLists = [];
    }
  }

  // To parse the UserTasks class into String
  String asString() {
    // An empty list of string to dump all TaskLists in UserTasks
    List<String> userTasksStringDump = [];

    // For every task list
    for (TaskList taskList in taskLists) {
      // An empty list of string to dump data about taskLists
      List<String> taskListStringList = [];

      // Get List Name and Dump on top
      String listName = taskList.listName;
      taskListStringList.add(listName);

      // An empty list of string to dump Task data
      List<String> taskStringList = [];

      // For each Task in TaskList
      for (Task task in taskList.tasksList) {
        // Read Task data
        String taskName = task.taskName;
        String taskChecked = task.checked.toString();

        // Dump Task data to taskStringList
        taskStringList.add("$taskName^|^$taskChecked");
      }

      // Dump list of Tasks in TaskList String dump
      taskListStringList.add(taskStringList.join("^||^"));
      userTasksStringDump.add(taskListStringList.join("^|||^"));
    }
    return userTasksStringDump.join("^||||^");
  }
}
