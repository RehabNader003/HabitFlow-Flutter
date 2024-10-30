import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'TaskItem.dart';
import 'habitDialog.dart';

class Today extends StatefulWidget {
  const Today({super.key});

  @override
  _TodayState createState() => _TodayState();
}

class _TodayState extends State<Today> {
  List<DocumentSnapshot> dailyTasks = [];
  List<DocumentSnapshot> monthlyTasks = [];
  List<DocumentSnapshot> completedTasks = [];
  List<DocumentSnapshot> uncompletedTasks = []; // New list for uncompleted tasks

  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    getData();
    getCompletedTasks();
  }

  getData() async {
    if (userId != null) {
      DateTime today = DateTime.now();
      int todayWeekday = today.weekday + 1; // 1 for Monday, 2 for Tuesday, etc.
      int todayDay = today.day; // Day of the month

      // Fetch daily tasks and filter them by today's weekday
      QuerySnapshot dailySnapshot = await FirebaseFirestore.instance
          .collection("daily")
          .where("user_id", isEqualTo: userId)
          .get();

      dailyTasks = dailySnapshot.docs.where((task) {
        List<dynamic> repeatDays = task['repeat_days'] ?? [];
        return repeatDays.contains(todayWeekday);
      }).toList();

      // Fetch monthly tasks and filter them by today's day of the month
      QuerySnapshot monthlySnapshot = await FirebaseFirestore.instance
          .collection("monthly")
          .where("user_id", isEqualTo: userId)
          .get();

      monthlyTasks = monthlySnapshot.docs.where((task) {
        List<dynamic> repeatDates = task['repeat_dates'] ?? [];
        return repeatDates.contains(todayDay);
      }).toList();

      // Save uncompleted tasks to Firestore
      await saveUncompletedTasks();

      if (mounted) {
        setState(() {});
      }
    } else {
      print("No user is signed in.");
    }
  }

  Future<void> saveUncompletedTasks() async {
    if (userId != null) {
      try {
        // Clear existing uncompleted tasks
        await FirebaseFirestore.instance.collection("uncompleted").where("user_id", isEqualTo: userId).get().then((snapshot) {
          for (var doc in snapshot.docs) {
            doc.reference.delete(); // Remove old uncompleted tasks
          }
        });

        // Add daily tasks to uncompleted tasks
        for (var task in dailyTasks) {
          Map<String, dynamic> taskData = {
            'task_name': task['task_name'],
            'date': DateTime.now(),
            'user_id': userId,
          };
          await FirebaseFirestore.instance.collection("uncompleted").add(taskData);
        }

        // Add monthly tasks to uncompleted tasks
        for (var task in monthlyTasks) {
          Map<String, dynamic> taskData = {
            'task_name': task['task_name'],
            'date': DateTime.now(),
            'user_id': userId,
          };
          await FirebaseFirestore.instance.collection("uncompleted").add(taskData);
        }
      } catch (e) {
        print("Error saving uncompleted tasks: $e");
      }
    }
  }

  Future<void> getCompletedTasks() async {
    if (userId != null) {
      try {
        QuerySnapshot completedSnapshot = await FirebaseFirestore.instance
            .collection("completeTasks")
            .where("user_id", isEqualTo: userId)
            .get();

        if (mounted) {
          setState(() {
            completedTasks = completedSnapshot.docs;
          });
        }
      } catch (e) {
        print("Error fetching completed tasks: $e");
      }
    }
  }

  void markTaskAsCompleted(DocumentSnapshot task, String collection) async {
    try {
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(task.id)
          .update({'completed': true});

      Map<String, dynamic> taskData = {
        'task_name': task['task_name'],
        'description': task['description'],
        'color': task['color'],
        'user_id': task['user_id'],
        'completed': true,
        'completed_at': FieldValue.serverTimestamp(),
      };

      if (collection == "daily") {
        taskData['repeat_days'] = task['repeat_days'];
      } else if (collection == "monthly") {
        taskData['repeat_dates'] = task['repeat_dates'];
      }

      await FirebaseFirestore.instance.collection("completeTasks").add(taskData);

      await FirebaseFirestore.instance.collection(collection).doc(task.id).delete();

      // Remove the task from uncompleted collection
      await removeTaskFromUncompleted(task);

      setState(() {
        if (collection == "daily") {
          dailyTasks.remove(task);
        } else if (collection == "monthly") {
          monthlyTasks.remove(task);
        }
        completedTasks.add(task);
      });
    } catch (e) {
      print("Error marking task as completed: $e");
    }
  }

  Future<void> removeTaskFromUncompleted(DocumentSnapshot task) async {
    if (userId != null) {
      try {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection("uncompleted")
            .where("task_name", isEqualTo: task['task_name'])
            .where("user_id", isEqualTo: userId)
            .get();

        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }
      } catch (e) {
        print("Error removing task from uncompleted: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        for (var task in dailyTasks)
          TaskItem(
            icon: Icons.track_changes,
            TaskName: task['task_name'],
            TaskColor: Color(task['color']),
            trailing: IconButton(
              icon: const Icon(
                Icons.check_circle_outline,
                color: Colors.white,
              ),
              onPressed: () {
                markTaskAsCompleted(task, "daily");
              },
            ),
            onLongPress: () {
              HabitOptionsDialog.showHabitOptionsDialog(
                context,
                task.id,
                task['task_name'],
                    () => HabitOptionsDialog().editHabit(context, task.id, "daily"), // Edit for daily habit
                    () => HabitOptionsDialog().deleteHabit(context, task.id, "daily"), // Delete for daily habit
                "daily",
              );
            },
          ),

        const SizedBox(height: 10),

        for (var task in monthlyTasks)
          TaskItem(
            icon: Icons.track_changes,
            TaskName: task['task_name'],
            TaskColor: Color(task['color']),
            trailing: IconButton(
              icon: const Icon(
                Icons.check_circle_outline,
                color: Colors.white,
              ),
              onPressed: () {
                markTaskAsCompleted(task, "monthly");
              },
            ),
            onLongPress: () {
              HabitOptionsDialog.showHabitOptionsDialog(
                context,
                task.id,
                task['task_name'],
                    () => HabitOptionsDialog().editHabit(context, task.id, "monthly"), // Edit for monthly habit
                    () => HabitOptionsDialog().deleteHabit(context, task.id, "monthly"), // Delete for monthly habit
                "monthly",
              );
            },
          ),

        const SizedBox(height: 10),
        const Row(
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
        const SizedBox(height: 10),

        for (var completedTask in completedTasks)
          TaskItem(
            icon: Icons.check_circle,
            TaskName: completedTask['task_name'],
            TaskColor: Colors.green,
            onLongPress: () {
              HabitOptionsDialog.showHabitOptionsDialog(
                context,
                completedTask.id,
                completedTask['task_name'],
                    () => HabitOptionsDialog().editHabit(context, completedTask.id, "completeTasks"), // Edit for completed task
                    () => HabitOptionsDialog().deleteHabit(context, completedTask.id, "completeTasks"), // Delete for completed task
                "completeTasks",
              );
            },
          ),
      ],
    );
  }
}