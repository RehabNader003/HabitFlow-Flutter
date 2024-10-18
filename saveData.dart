// ignore_for_file: depend_on_referenced_packages, deprecated_member_use
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habit_project/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HabitService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Save habit to Firestore
  static Future<void> saveHabitToFirestore(
      {required String habitName,
      required String habitDescription,
      required bool isDaily,
      required bool isMonthly,
      required Color color,
      List<DateTime?>? selectedDates,
      List<int>? selectedDays,
      required bool reminderEnabled,
      TimeOfDay? reminderTime,
      int id = 0 // Change to TimeOfDay
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
      if (reminderEnabled && reminderTime != null) {
        NotificationHandler.scheduleNotification(
            'alarm', "time to make $habitName", id, reminderTime);
      }
      id += 1;
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
}
