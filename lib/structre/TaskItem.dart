import 'package:flutter/material.dart';

class TaskItem extends StatelessWidget {
  final String TaskName;
  final Color TaskColor;
  final IconData? icon; // Leading icon
  final Widget? trailing; // Trailing widget
  final VoidCallback? onLongPress;

  const TaskItem({
    super.key,
    required this.TaskName,
    required this.TaskColor,
    this.icon,
    this.trailing,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: TaskColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Distribute items across the row
          children: [
            // Leading icon and task name
            Row(
              children: [
                Icon(icon, color: Colors.white), // Display the icon if provided
                const SizedBox(
                    width: 8), // Add some spacing between the icon and the text
                Text(
                  TaskName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
      
            // Trailing widget (icon or button)
            if (trailing != null)
              trailing!, // Display the trailing widget if provided
          ],
        ),
      ),
    );
  }
}
