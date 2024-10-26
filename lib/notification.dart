import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize notification settings
  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher'); // App icon

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Create a notification channel for Android 8.0+ devices
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // name
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Show notification
  Future<void> showNotification(String taskName) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Uncompleted Task',
      'You still need to complete: $taskName',
      platformChannelSpecifics,
    );
  }
}

class NotificationHandler {
  static final FlutterLocalNotificationsPlugin _notification =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    _notification.initialize(const InitializationSettings(
      android: AndroidInitializationSettings(
          '@mipmap/ic_launcher'), // Define your launcher icon here
      iOS: DarwinInitializationSettings(),
    ));

    tz.initializeTimeZones();
  }

  static Future<void> scheduleNotification(
      String title, String body, int id, TimeOfDay timeOfDay) async {
    // Check if it's AM or PM and append it to the body
    String period = timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';
    body =
        '⏰ $body at ${timeOfDay.hourOfPeriod}:${timeOfDay.minute.toString().padLeft(2, '0')} $period'; // Add icon and time

    // Android notification details
    var androidDetails = const AndroidNotificationDetails(
      'important_notification',
      'my channel',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: '@mipmap/ic_launcher', // Add an icon for the notification
    );

    // iOS notification details
    var iosDetails =
        const DarwinNotificationDetails(); // Add sound for iOS if needed

    // Notification details for both platforms
    var notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    // Schedule the notification based on the time provided
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDateTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    // If the scheduled time is in the past, schedule it for the next day
    if (scheduledDateTime.isBefore(now)) {
      scheduledDateTime = scheduledDateTime.add(const Duration(days: 1));
    }

    // Schedule the notification
    await _notification.zonedSchedule(
        id, title, body, scheduledDateTime, notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);

    // Optionally, show the notification immediately (if you want immediate feedback)
    _notification.show(id, title, body, notificationDetails);
  }
}
