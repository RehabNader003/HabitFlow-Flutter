import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHandler {
  static final _notification = FlutterLocalNotificationsPlugin();

  static init() {
    _notification.initialize(const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    ));

    tz.initializeTimeZones();
  }

  static scheduleNotification(
      String title, String body, int id, TimeOfDay timeOfDay) async {
    var androidDetails = const AndroidNotificationDetails(
      'important_notification',
      'my channel',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    var iosDetails =
        const DarwinNotificationDetails(); // Add sound for iOS if needed
    var notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    final now = DateTime.now();

    tz.TZDateTime scheduledDateTime = tz.TZDateTime.now(tz.local)
        .add(Duration(
          hours: timeOfDay.hour - now.hour,
          minutes: timeOfDay.minute - now.minute,
        ))
        .add(const Duration(milliseconds: 3));

    if (scheduledDateTime.isBefore(tz.TZDateTime.now(tz.local))) {
      scheduledDateTime = scheduledDateTime.add(const Duration(days: 1));
    }

    await _notification.zonedSchedule(
        id, title, body, scheduledDateTime, notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
    _notification.show(id, title, body, notificationDetails);
  }
}
