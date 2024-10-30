import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LineChartPage extends StatelessWidget {
  final String selectedTimeframe;
  final String selectedHabit;

  LineChartPage({
    required this.selectedTimeframe,
    required this.selectedHabit,
  });

  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<FlSpot>>(
          future: _getChartData(selectedTimeframe, selectedHabit),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text("No data available for the selected habit/timeframe"),
              );
            }
            return LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: _getBottomTitles,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: _getLeftTitles,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: snapshot.data!,
                    isCurved: true,
                    barWidth: 2,
                    color: Colors.blue,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<List<FlSpot>> _getChartData(String timeframe, String habit) async {
    List<double> rawData;

    if (habit == 'All') {
      rawData = await _getAllHabitData(timeframe);
    } else {
      rawData = await _getSpecificHabitData(timeframe, habit);
    }

    return List<FlSpot>.generate(
      rawData.length,
          (index) => FlSpot(index.toDouble(), rawData[index]),
    );
  }

  Future<List<double>> _getSpecificHabitData(String timeframe, String habit) async {
    DateTime startDate, endDate;
    final now = DateTime.now();

    switch (timeframe) {
      case 'This Week':
        startDate = now.subtract(Duration(days: (now.weekday % 7) + 2));
        endDate = startDate.add(Duration(days: 6));
        break;
      case 'This Month':
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 1).subtract(Duration(days: 1));
        break;
      case 'This Year':
        startDate = DateTime(now.year, 1, 1);
        endDate = DateTime(now.year, 12, 31);
        break;
      default:
        startDate = now;
        endDate = now;
    }

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('completeTasks')
          .where('user_id', isEqualTo: userId)
          .where('task_name', isEqualTo: habit.toLowerCase())
          .where('completed_at', isGreaterThanOrEqualTo: startDate)
          .where('completed_at', isLessThanOrEqualTo: endDate)
          .orderBy('completed_at')
          .get();

      List<double> data;

      // Set the size of the data list based on the timeframe
      if (timeframe == 'This Year') {
        data = List.filled(12, 0.0); // One for each month
      } else {
        data = List.filled(_getDateRangeDaysCount(startDate, endDate), 0.0); // Daily count for other timeframes
      }

      for (var doc in querySnapshot.docs) {
        DateTime date = (doc['completed_at'] as Timestamp).toDate();
        int index;


        if (timeframe == 'This Year') {
          index = date.month - 1; // Months are 1-indexed, adjust to 0-indexed
        } else {
          index = date.difference(startDate).inDays;
        }

        if (index >= 0 && index < data.length) {
          data[index] += 1;
        }
      }
      return data;
    } catch (error) {
      print("Error retrieving specific habit data: $error");
      rethrow;
    }
  }

  Future<List<double>> _getAllHabitData(String timeframe) async {
    DateTime startDate, endDate;
    final now = DateTime.now();

    switch (timeframe) {
      case 'This Week':
        startDate = now.subtract(Duration(days: (now.weekday % 7) + 2));
        endDate = startDate.add(Duration(days: 6));
        break;
      case 'This Month':
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 1).subtract(Duration(days: 1));
        break;
      case 'This Year':
        startDate = DateTime(now.year, 1, 1);
        endDate = DateTime(now.year, 12, 31);
        break;
      default:
        startDate = now;
        endDate = now;
    }

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('completeTasks')
          .where('user_id', isEqualTo: userId)
          .where('completed_at', isGreaterThanOrEqualTo: startDate)
          .where('completed_at', isLessThanOrEqualTo: endDate)
          .orderBy('completed_at')
          .get();

      List<double> data;

      // Set the size of the data list based on the timeframe
      if (timeframe == 'This Year') {
        data = List.filled(12, 0.0); // One for each month
      } else {
        data = List.filled(_getDateRangeDaysCount(startDate, endDate), 0.0); // Daily count for other timeframes
      }

      for (var doc in querySnapshot.docs) {
        DateTime date = (doc['completed_at'] as Timestamp).toDate();
        int index;

        if (timeframe == 'This Year') {
          index = date.month - 1; // Months are 1-indexed, adjust to 0-indexed
        } else {
          index = date.difference(startDate).inDays;
        }

        if (index >= 0 && index < data.length) {
          data[index] += 1; // Increment the count for the corresponding day or month
        }
      }
      return data;
    } catch (error) {
      print("Error retrieving all habit data: $error");
      rethrow;
    }
  }

  int _getDateRangeDaysCount(DateTime start, DateTime end) {
    return end.difference(start).inDays + 1;
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 12);
    String text;

    switch (selectedTimeframe) {
      case 'This Week':
        switch (value.toInt()) {
          case 0:
            text = 'Sat';
            break;
          case 1:
            text = 'Sun';
            break;
          case 2:
            text = 'Mon';
            break;
          case 3:
            text = 'Tue';
            break;
          case 4:
            text = 'Wed';
            break;
          case 5:
            text = 'Thu';
            break;
          case 6:
            text = 'Fri';
            break;
          default:
            text = '';
        }
        break;
      case 'This Month':
        text = 'Week ${value.toInt() + 1}';
        break;
      case 'This Year':
        text = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ][value.toInt()];
        break;
      default:
        text = '';
    }
    return SideTitleWidget(
      child: Text(text, style: style),
      axisSide: meta.axisSide,
    );
  }

  Widget _getLeftTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 12);
    return SideTitleWidget(
      child: Text(value.toInt().toString(), style: style),
      axisSide: meta.axisSide,
    );
  }
}
