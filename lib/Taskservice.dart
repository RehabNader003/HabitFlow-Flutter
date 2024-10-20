import 'package:cloud_firestore/cloud_firestore.dart';
import 'notification_service.dart'; // Import the service

class TaskService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final NotificationService notificationService = NotificationService();

  // Fetch uncompleted tasks for the current date
  Future<void> checkUncompletedTasks() async {
    DateTime now = DateTime.now();
    String currentDate = "${now.year}-${now.month}-${now.day}"; // Format the current date

    QuerySnapshot tasksSnapshot = await firestore
        .collection('uncompletedTasks')
        .where('date', isEqualTo: currentDate)
        .get();

    // Send a notification for each uncompleted task
    for (var task in tasksSnapshot.docs) {
      String taskName = task['task_name'];
      notificationService.showNotification(taskName); // Call the notification function
    }
  }
}
