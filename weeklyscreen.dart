import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore import
import 'package:collection/collection.dart'; // For groupBy

class WeeklyHabitsScreen extends StatelessWidget {
  WeeklyHabitsScreen({super.key});
  final CollectionReference habitCollection =
  FirebaseFirestore.instance.collection('daily');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly'),
        backgroundColor: const Color(0xFF8985E9),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: habitCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Loading spinner
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching habits')); // Error handling
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No habits found')); // No data handling
          }

          // List to hold all habits grouped by individual days
          Map<int, List<QueryDocumentSnapshot>> habitsByDay = {};

          // Iterate through each document and add the habit to each day it repeats on
          for (var doc in snapshot.data!.docs) {
            List<dynamic> repeatDays = doc['repeat_days'] as List<dynamic>;
            for (var day in repeatDays) {
              if (day is int) {
                if (habitsByDay.containsKey(day)) {
                  habitsByDay[day]!.add(doc);
                } else {
                  habitsByDay[day] = [doc];
                }
              }
            }
          }

          return ListView.builder(
            itemCount: habitsByDay.keys.length,
            itemBuilder: (context, index) {
              int day = habitsByDay.keys.elementAt(index);
              List<QueryDocumentSnapshot> habitsForDay = habitsByDay[day]!;
              String dayName = getDayName(day);

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ExpansionTile(
                    textColor: const Color(0xFFFFFFFF),
                    backgroundColor: const Color(0xFF8985E9),
                    title: Text(
                      dayName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: habitsForDay.map((habit) {
                      return ListTile(
                        title: Text(
                          habit['task_name'] ?? 'Unknown', // Display task name
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(habit['description'] ?? 'No description'), // Display description
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String getDayName(int day) {
    switch (day) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Unknown';
    }
  }
}
