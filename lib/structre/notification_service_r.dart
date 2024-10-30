import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServiceR {
  // Firestore instance
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firebase Messaging instance
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Local Notifications instance
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Define channel ID
  static const String channelId = '2'; // Updated channel ID to "2"

  // Initialize notifications
  static Future<void> initializeNotifications() async {
    // Request permission for notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }

    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon'); // Ensure to use your app icon name
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Handle background notifications
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Background message handler
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  // Method to check for uncompleted tasks and send notifications
  static Future<void> checkAndSendUncompletedTaskNotifications() async {
    final DateTime now = DateTime.now().toUtc();

    // Query uncompleted tasks for the current date
    QuerySnapshot querySnapshot = await _firestore
        .collection('uncompletedTasks')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(now.year, now.month, now.day, 0, 0, 0)))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(DateTime(now.year, now.month, now.day, 23, 59, 59)))
        .get();

    // Extract task names from the query results
    List<String> uncompletedTaskNames = querySnapshot.docs.map((doc) => doc['task_name'] as String).toList();

    // Check if there are uncompleted tasks
    if (uncompletedTaskNames.isNotEmpty) {
      // Construct and send notification
      String message = "You have uncompleted tasks: ${uncompletedTaskNames.join(', ')}";
      await _showNotification("Uncompleted Tasks", message);
    } else {
      print("No uncompleted tasks for today.");
    }
  }

  // Method to show the notification
  static Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      channelId, // Use the channel ID here
      'Uncompleted Tasks Channel', // Replace with your channel name
      channelDescription: 'Channel for uncompleted tasks notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x', // Optional payload
    );
  }
}
