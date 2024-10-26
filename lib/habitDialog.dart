import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_app/update_page.dart';

class HabitOptionsDialog {
  // Firestore collections
  final CollectionReference dailyCollection =
  FirebaseFirestore.instance.collection('daily');
  final CollectionReference monthlyCollection =
  FirebaseFirestore.instance.collection('monthly');
  final CollectionReference completeTasksCollection =
  FirebaseFirestore.instance.collection('completeTasks');

  static void showHabitOptionsDialog(
      BuildContext context,
      String habitId,
      String habitName,
      Function onEdit,
      Function onDelete,
      String collection) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Options for "$habitName"'),
          content: const Text('What would you like to do?',
              style: TextStyle(color: Color(0xFF8985E9), fontSize: 16)),
          actions: [
            // Cancel button closes the dialog
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog when Cancel is pressed
              },
              child: const Text('Cancel',
                  style: TextStyle(color: Color(0xFF6B6868))),
            ),
            // Delete button deletes the habit and closes the dialog
            TextButton(
              onPressed: () {
                onDelete(); // Call the delete function
                Navigator.pop(context); // Close dialog after deletion
              },
              child: const Text('Delete',
                  style: TextStyle(
                    color: Color(0xFFFF0000),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            // Edit button closes the dialog and calls the edit function
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                onEdit(); // Call the edit function
              },
              child: const Text('Update',
                  style: TextStyle(
                    color: Color(0xFF8985E9),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ],
        );
      },
    );
  }

  // Delete habit from Firestore for all collections
  void deleteHabit(
      BuildContext context, String habitId, String collection) async {
    try {
      final CollectionReference habitCollection = _getCollection(collection);

      await habitCollection.doc(habitId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Habit deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete habit: $e')),
      );
    }
  }

  // Edit habit from Firestore for all collections
  void editHabit(BuildContext context, String habitId, String collection) async {
    final CollectionReference habitCollection = _getCollection(collection);

    // Fetch the existing habit data from Firestore
    DocumentSnapshot habitSnapshot = await habitCollection.doc(habitId).get();

    if (habitSnapshot.exists) {
      Map<String, dynamic> habitData =
      habitSnapshot.data() as Map<String, dynamic>;

      // Ensure all required fields are included in the habitData
      habitData.putIfAbsent('habitName', () => habitSnapshot.get("task_name"));
      habitData.putIfAbsent(
          'description', () => habitSnapshot.get("description"));
      habitData.putIfAbsent('color', () => 0xFFFFFFFF); // Default color
      habitData.putIfAbsent('selectedDays', () => []); // For daily tasks
      habitData.putIfAbsent('selectedDates', () => []); // For monthly tasks
      habitData.putIfAbsent('reminderEnabled', () => false);
      habitData.putIfAbsent('reminderTime', () => null);

      // Ensure 'reminderTime' is converted correctly from Firestore Timestamp to TimeOfDay
      if (habitData['reminderTime'] != null) {
        habitData['reminderTime'] =
            (habitData['reminderTime'] as Timestamp).toDate();
      }

      // Navigate to UpdatePage with the habit data
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => UpdatePage(
            habitId: habitId,
            habitData: habitData,
            collection: collection, // Pass collection type to UpdatePage
          ),
        ),
      );
    }
  }

  // Get the correct Firestore collection based on the provided collection type
  CollectionReference _getCollection(String collection) {
    switch (collection) {
      case 'daily':
        return dailyCollection;
      case 'monthly':
        return monthlyCollection;
      case 'completeTasks':
        return completeTasksCollection;
      default:
        throw Exception('Unknown collection: $collection');
    }
  }
}
