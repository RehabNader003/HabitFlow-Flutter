
import 'package:flutter/material.dart';

class TaskItem extends StatelessWidget {
  final String TaskName;
  final Color TaskColor;
  final IconData? icon;

  TaskItem({required this.TaskName, required this.TaskColor, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: TaskColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

            Icon(icon, color: Colors.white), // Display the icon if provided
            SizedBox(width: 2), // Add some spacing between the icon and the text

          Text(
            TaskName,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),


        ],
      ),
    );
  }
}