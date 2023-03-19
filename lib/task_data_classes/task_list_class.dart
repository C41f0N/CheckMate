import 'package:sarims_todo_app/task_data_classes/task_class.dart';

class TaskList {
  
  List<Task> tasksList;
  String listName;

  TaskList(this.listName, this.tasksList);
}
