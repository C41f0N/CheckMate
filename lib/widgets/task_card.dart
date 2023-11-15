import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:check_mate/config.dart';

// ignore: must_be_immutable
class TaskCard extends StatefulWidget {
  TaskCard(
      {super.key,
      required this.taskName,
      required this.completed,
      required this.onTaskCheckChange,
      required this.onDelete,
      required this.reorderingMode,
      required this.enabled,
      required this.onEditTaskName});

  final String taskName;
  bool completed;
  final Function onTaskCheckChange;
  final Function onDelete;
  final bool reorderingMode;
  final bool enabled;
  final Function onEditTaskName;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  void onDeleteWithContext(BuildContext context) {
    widget.onDelete(widget.taskName);
  }

  void onEditTaskNameWithContext(BuildContext context) {
    widget.onEditTaskName(widget.taskName);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        12.0,
        6,
        12.0,
        6,
      ),
      child: Slidable(
        enabled: widget.enabled && !widget.reorderingMode,
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(4),
              backgroundColor: Colors.red[900]!,
              icon: Icons.delete,
              onPressed: onDeleteWithContext,
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(4),
              backgroundColor: Theme.of(context).colorScheme.primary,
              icon: Icons.edit,
              onPressed: onEditTaskNameWithContext,
            ),
          ],
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            key: UniqueKey(),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  widget.reorderingMode
                      ? Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(
                            Icons.menu,
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondary
                                .withOpacity(0.7),
                          ),
                        )
                      : Checkbox(
                          activeColor: Theme.of(context).colorScheme.primary,
                          checkColor: currentTheme.isDark()
                              ? Colors.grey[900]
                              : Colors.white,
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                          value: widget.completed,
                          onChanged: (checked) {
                            onTap();
                          },
                        ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: AutoSizeText(
                      minFontSize: 20,
                      widget.taskName,
                      style: TextStyle(
                        color: widget.completed
                            ? Theme.of(context)
                                .colorScheme
                                .onSecondary
                                .withOpacity(0.2)
                            : Theme.of(context).colorScheme.onSecondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        decoration: widget.completed
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onTap() {
    if (!widget.reorderingMode && widget.enabled) {
      widget.completed = !widget.completed;
      widget.onTaskCheckChange(widget.taskName, widget.completed);
      setState(() {});
    }
  }
}
