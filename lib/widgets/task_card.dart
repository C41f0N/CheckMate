import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:swipeable_tile/swipeable_tile.dart';

class TaskCard extends StatelessWidget {
  const TaskCard(
      {super.key,
      required this.taskName,
      required this.completed,
      required this.onTaskCheckChange,
      required this.onDelete,
      required this.reorderingMode});

  final String taskName;
  final bool completed;
  final Function onTaskCheckChange;
  final Function onDelete;
  final bool reorderingMode;

  void onDeleteWithContext(BuildContext context) {
    onDelete(taskName);
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
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              backgroundColor: Colors.redAccent,
              icon: Icons.delete,
              onPressed: onDeleteWithContext,
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            if (!reorderingMode) {
              onTaskCheckChange(taskName, completed);
            }
          },
          child: Container(
            key: UniqueKey(),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: completed
                  ? reorderingMode
                      ? Colors.grey[800]!.withOpacity(0.7)
                      : Colors.grey[800]
                  : reorderingMode
                      ? Theme.of(context).colorScheme.secondary.withOpacity(0.7)
                      : Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  reorderingMode
                      ? const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(Icons.menu),
                        )
                      : Checkbox(
                          value: completed,
                          onChanged: ((completed) {
                            if (!reorderingMode) {
                              onTaskCheckChange(taskName, completed);
                            }
                          })),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: AutoSizeText(
                      taskName,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                          decoration: completed
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
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
