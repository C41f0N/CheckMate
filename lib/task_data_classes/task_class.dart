class Task {
  String taskName;
  bool checked;

  Task(this.taskName, this.checked);

  toggleCompletion() {
    checked = !checked;
  }

}
