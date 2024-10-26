import 'package:flutter/material.dart';
import 'line_chart_page.dart'; // Import the LineChartPage
import 'package:cloud_firestore/cloud_firestore.dart'; // Required for Firebase collections

class Chartpage extends StatefulWidget {
  @override
  _ChartpageState createState() => _ChartpageState();
}

class _ChartpageState extends State<Chartpage> {
  String _selectedTimeframe = 'This Week'; // Store the selected timeframe
  String _selectedHabit = 'Habit 1'; // Store the selected habit
  List<String> _habits = []; // List to store habits from Firestore

  int totalHabits = 0; // Total number of habits
  int completedHabits = 0; // Number of completed habits
  int uncompletedHabits = 0; // Number of uncompleted habits
  double completionRate = 0.0; // Completion rate in percentage

  @override
  void initState() {
    super.initState();
    _fetchHabits(); // Fetch habits when the widget initializes
    _fetchStatistics(); // Fetch statistics for total and completed habits
  }

  Future<void> _fetchHabits() async {
    // Fetch unique task names from the completeTasks collection
    var habits = await _getUniqueHabits();
    if (mounted) {
      setState(() {
        _habits = habits;
        _habits.add('All'); // Add 'All' option to the habits
        if (_habits.isNotEmpty) {
          _selectedHabit = _habits[0]; // Default to the first habit
        }
      });
    }
  }

  Future<List<String>> _getUniqueHabits() async {
    // Fetch unique task names from Firestore
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('completeTasks').get();

    // Extract unique habit names
    final Set<String> habitSet = {};
    for (var doc in querySnapshot.docs) {
      habitSet.add(doc['task_name']);
    }
    return habitSet.toList();
  }

  Future<void> _fetchStatistics() async {
    // Fetch total habits (completed + uncompleted) and completion rate
    final QuerySnapshot completedSnapshot =
        await FirebaseFirestore.instance.collection('completeTasks').get();

    final QuerySnapshot uncompletedSnapshot =
        await FirebaseFirestore.instance.collection('uncompletedTasks').get();

    int completedCount = completedSnapshot.docs.length;
    int uncompletedCount = uncompletedSnapshot.docs.length;
    int totalCount = completedCount + uncompletedCount;

    setState(() {
      totalHabits = totalCount;
      completedHabits = completedCount;
      uncompletedHabits = uncompletedCount;
      completionRate =
          totalCount > 0 ? (completedCount / totalCount) * 100 : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Light background color
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: Text(
                'Habit Statistics',
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
            ),
          ),
          // Card-based stats for better visuals
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: _buildStatCard("Total Habits", "$totalHabits",
                        Icons.list, Colors.purple)),
                Expanded(
                    child: _buildStatCard("Completed Habits",
                        "$completedHabits", Icons.check_circle, Colors.green)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: _buildStatCard("Uncompleted Habits",
                        "$uncompletedHabits", Icons.cancel, Colors.red)),
                Expanded(
                    child: _buildStatCard(
                        "Completion Rate",
                        "${completionRate.toStringAsFixed(2)}%",
                        Icons.show_chart,
                        Colors.orange)),
              ],
            ),
          ),

          SizedBox(height: 16),
          // Add DropdownButton for Timeframe Selection
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropdownButton<String>(
                value: _selectedTimeframe,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTimeframe = newValue!;
                  });
                },
                items: <String>['This Week', 'This Month', 'This Year']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              DropdownButton<String>(
                value: _selectedHabit,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedHabit = newValue!;
                  });
                },
                items: _habits.isNotEmpty
                    ? _habits.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList()
                    : [],
              ),
            ],
          ),
          SizedBox(height: 16),
          // Expanded widget to increase chart size
          Expanded(
            flex: 2, // Increase the chart area size
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LineChartPage(
                selectedTimeframe:
                    _selectedTimeframe, // Pass selected timeframe parameter
                selectedHabit: _selectedHabit, // Pass selected habit parameter
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 10, horizontal: 10), // Reduce padding for smaller boxes
        child: Column(
          children: [
            Icon(icon, size: 24, color: color), // Smaller icon
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                  fontSize: 14, color: Colors.grey[800]), // Smaller title text
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color), // Smaller value text
            ),
          ],
        ),
      ),
    );
  }
}
