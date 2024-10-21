
import 'package:flutter/material.dart';

class TaskItem extends StatelessWidget {
  final String TaskName;
  final Color TaskColor;
  final IconData? icon;
  final bool isCompleted;
  final ValueChanged<bool?>? onCompletedChanged;

  TaskItem({
    required this.TaskName,
    required this.TaskColor,
    required this.icon,
    required this.isCompleted,
    this.onCompletedChanged,});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: TaskColor),
      title: Text(TaskName),
      trailing: Checkbox(
        value: isCompleted,
        onChanged: onCompletedChanged, // Checkbox change callback
      ),
    );
  }
}
