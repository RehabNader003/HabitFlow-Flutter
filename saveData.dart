// ignore_for_file: depend_on_referenced_packages, deprecated_member_use
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HabitService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Save habit to Firestore
  static Future<void> saveHabitToFirestore({
    required String habitName,
    required String habitDescription,
    required bool isDaily,
    required bool isMonthly,
    required Color color,
    List<DateTime?>? selectedDates,
    List<int>? selectedDays,
    required bool reminderEnabled,
    TimeOfDay? reminderTime, // Change to TimeOfDay
  }) async {
    CollectionReference dailyCollection =
        FirebaseFirestore.instance.collection('daily');
    CollectionReference monthlyCollection =
        FirebaseFirestore.instance.collection('monthly');

    if (isDaily && selectedDays != null && selectedDays.isNotEmpty) {
      await dailyCollection.add({
        'task_name': habitName,
        'description': habitDescription,
        'alarm': reminderEnabled,
        'color': color.value,
        'repeat_days': selectedDays,
        'reminder_time': reminderTime != null
            ? {'hour': reminderTime.hour, 'minute': reminderTime.minute}
            : null, // Store hour and minute only
      });
      // if (reminderEnabled && reminderTime != null) {
      //   scheduleNotification(habitName, reminderTime); // Schedule notification
      // }
    }

    if (isMonthly && selectedDates != null && selectedDates.isNotEmpty) {
      await monthlyCollection.add({
        'task_name': habitName,
        'description': habitDescription,
        'repeat_dates': selectedDates
            .where((date) => date != null)
            .map((date) =>
                date!.day) // Store the day of the month (e.g., 1, 15, 30)
            .toList(),
        'color': color.value,
      });
    }
  }

  // Schedule notification using TimeOfDay
  static Future<void> scheduleNotification(
      String habitName, TimeOfDay reminderTime) async {
    tz.initializeTimeZones();
    final now = tz.TZDateTime.now(tz.local);

    // Convert TimeOfDay to the next DateTime instance with the same time
    final tz.TZDateTime scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      reminderTime.hour,
      reminderTime.minute,
    );

    // If the scheduled time has already passed for today, schedule for tomorrow
    if (scheduledTime.isBefore(now)) {
      scheduledTime.add(const Duration(days: 1));
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      'Reminder',
      'It\'s time to work on your habit: $habitName',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
