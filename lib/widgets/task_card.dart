import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sarims_todo_app/config.dart';

class TaskCard extends StatefulWidget {
  const TaskCard(
      {super.key,
      required this.taskName,
      required this.completed,
      required this.onTaskCheckChange,
      required this.onDelete,
      required this.reorderingMode,
      required this.enabled});

  final String taskName;
  final bool completed;
  final Function onTaskCheckChange;
  final Function onDelete;
  final bool reorderingMode;
  final bool enabled;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  void onDeleteWithContext(BuildContext context) {
    widget.onDelete(widget.taskName);
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
        enabled: widget.enabled,
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(4),
              backgroundColor: Colors.red[700]!,
              icon: Icons.delete,
              onPressed: onDeleteWithContext,
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            if (!widget.reorderingMode && widget.enabled) {
              widget.onTaskCheckChange(widget.taskName, widget.completed);
            }
          },
          child: Container(
            key: UniqueKey(),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: widget.completed
                  ? widget.reorderingMode
                      ? Colors.grey[800]!.withOpacity(0.7)
                      : Colors.grey[800]
                  : widget.reorderingMode
                      ? Theme.of(context).colorScheme.secondary.withOpacity(0.7)
                      : Theme.of(context).colorScheme.secondary,
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
                            color: widget.completed
                                ? Theme.of(context)
                                    .iconTheme
                                    .color
                                    ?.withOpacity(0.7)
                                : Theme.of(context).iconTheme.color,
                          ),
                        )
                      : Checkbox(
                          activeColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.7),
                          checkColor: currentTheme.isDark()
                              ? Colors.grey[900]
                              : Colors.white,
                          side: BorderSide(
                            color: currentTheme.isDark()
                                ? Colors.grey[800]!
                                : const Color.fromARGB(255, 234, 234, 234),
                            width: 2,
                          ),
                          value: widget.completed,
                          onChanged: ((completed) {
                            if (!widget.reorderingMode) {
                              widget.onTaskCheckChange(
                                widget.taskName,
                                completed,
                              );
                            }
                          }),
                        ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: AutoSizeText(
                      widget.taskName,
                      style: TextStyle(
                        color: currentTheme.isDark()
                            ? !widget.completed
                                ? Colors.black
                                : Colors.black.withOpacity(0.7)
                            : !widget.completed
                                ? Colors.grey[200]
                                : Colors.grey[200]!.withOpacity(0.5),
                        fontWeight: FontWeight.normal,
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
}
