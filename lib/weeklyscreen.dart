import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore import

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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching habits'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No habits found'));
          }

          // Process and filter habits for days with less than 6 selected days
          final habitsByDay = _groupHabitsByDay(snapshot.data!.docs);

          return ListView.builder(
            itemCount: habitsByDay.keys.length,
            itemBuilder: (context, index) {
              int day = habitsByDay.keys.elementAt(index);
              List<QueryDocumentSnapshot> habitsForDay = habitsByDay[day]!;
              String dayName = _getDayName(day);

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
                      // Fetch the color from the Firestore document
                      int colorValue = habit['color'] ?? 0xFFFFFFFF; // Default to white if no color is found

                      return Container(
                        color: Color(colorValue), // Apply background color
                        child: ListTile(
                          title: Text(
                            habit['task_name'] ?? 'Unknown',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white, // Text color on colored background
                            ),
                          ),
                          subtitle: Text(
                            habit['description'] ?? 'No description',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
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

  /// Groups habits by day, but only includes those with less than 6 days selected.
  Map<int, List<QueryDocumentSnapshot>> _groupHabitsByDay(
      List<QueryDocumentSnapshot> documents) {
    final Map<int, List<QueryDocumentSnapshot>> habitsByDay = {};

    for (var doc in documents) {
      List<dynamic>? repeatDays = doc['repeat_days'] as List<dynamic>?;

      if (repeatDays != null && repeatDays.length < 6) {
        for (var day in repeatDays) {
          if (day is int) {
            habitsByDay.putIfAbsent(day, () => []).add(doc);
          }
        }
      }
    }

    return habitsByDay;
  }

  /// Returns the name of the day based on an integer.
  String _getDayName(int day) {
    const dayNames = [
      'Unknown', // Placeholder for index 0 (if needed)
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];

    return (day >= 1 && day <= 7) ? dayNames[day] : 'Unknown';
  }
}
