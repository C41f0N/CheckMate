import 'package:sarims_todo_app/task_data_classes/task_class.dart';
import 'package:sarims_todo_app/task_data_classes/task_list_class.dart';

class UserTasks {
  List<TaskList> taskLists = [];

  // To create default data
  createDefaultData() {
    taskLists = [
      TaskList("Important Stuff", [
        Task("Feed Dog", false),
        Task("Make Bed", false),
        Task("Work on world domination plan", true),
      ])
    ];
  }

  // To generate a UserTask instance from previously parsed data
  parse(String stringUserData) {
    // empty previously held data
    taskLists = [];

    // Split String into individual taskListData
    List<String> allTaskListDataInString = stringUserData.split("|||");

    for (String taskListDataInString in allTaskListDataInString) {
      // Split each taskListData into taskListName and tasksList(in String form / non parsed)
      taskListDataInString.split("||");
      String taskListName = taskListDataInString[0];
      List<String> taskListInString = taskListDataInString[1].split("||");

      // Parse tasksList into a List<Task>
      List<Task> tasksList = taskListInString.map((String taskDataInString) {
        String taskName = taskDataInString.split("|")[0];
        bool checked = taskDataInString.split("|")[1] == "true";

        return Task(taskName, checked);
      }).toList();

      // Create a TaskList instance from parsed data
      TaskList parsedTaskList = TaskList(taskListName, tasksList);

      // add TaskList to the taskLists array
      taskLists.add(parsedTaskList);
    }
  }

  asString() {
    // An empty list of string to dump all TaskLists in UserTasks
    List<String> userTasksStringDump = [];

    // For every task list
    for (TaskList taskList in taskLists) {
      // An empty list of string to dump taskList data
      List<String> taskListStringList = [];

      // Get List Name and Dump on top of String List
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
        taskStringList.add("$taskName|$taskChecked");
      }

      // Dump list of Tasks in TaskList String dump
      taskListStringList.add(taskStringList.join("||"));
      userTasksStringDump.add(taskListStringList.join("|||"));
    }
  }
}
