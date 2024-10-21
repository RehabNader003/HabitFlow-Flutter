import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'TaskItem.dart';

class Today extends StatefulWidget {
  @override
  _TodayState createState() => _TodayState();
}

class _TodayState extends State<Today> {
  List<QueryDocumentSnapshot> activeTasks = [];
  List<QueryDocumentSnapshot> completedTasks = [];

  // Fetch data from Firestore
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("daily").get();
    setState(() {
      // Separate completed and uncompleted tasks
      activeTasks = querySnapshot.docs.where((task) => !(task['completed'] ?? false)).toList();
      completedTasks = querySnapshot.docs.where((task) => (task['completed'] ?? false)).toList();
    });
  }

  // Function to mark a task as completed
  markTaskAsCompleted(QueryDocumentSnapshot task) async {
    await FirebaseFirestore.instance.collection("daily").doc(task.id).update({'completed': true});
    setState(() {
      activeTasks.remove(task);
      completedTasks.add(task);
    });
  }

  @override
  void initState() {
    super.initState();
    getData(); // Fetch tasks when widget initializes
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        // Display active tasks
        for (var task in activeTasks)
          TaskItem(
            icon: Icons.track_changes,
            TaskName: task['task_name'], // Task title from Firestore
            TaskColor: Color(task['color']), // Task color from Firestore (saved as int)
            isCompleted: false,
            onCompletedChanged: (bool? value) {
              if (value == true) {
                markTaskAsCompleted(task); // Move to completed section
              }
            },
          ),
        SizedBox(height: 10),

        // Divider for Completed Tasks Section
        Row(
          children: <Widget>[
            Text('Completed'),
            SizedBox(width: 10),
            Expanded(
              child: Divider(
                color: Colors.black,
                thickness: 1,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),

        // Display completed tasks
        for (var task in completedTasks)
          TaskItem(
            icon: Icons.check_circle,
            TaskName: task['task_name'], // Task title from Firestore
            TaskColor: Color(task['color']), // Task color from Firestore (saved as int)
            isCompleted: true,
            onCompletedChanged: null, // No action needed for completed tasks
          ),
      ],
    );
  }
}
