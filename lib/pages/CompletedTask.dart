import 'package:flutter/material.dart';

class CompletedTask extends StatelessWidget {
  final String TaskName;
  final Color TaskColor;

  const CompletedTask(
      {super.key, required this.TaskName, required this.TaskColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: TaskColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            TaskName,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const Icon(Icons.check_circle, color: Colors.white),
        ],
      ),
    );
  }
}
