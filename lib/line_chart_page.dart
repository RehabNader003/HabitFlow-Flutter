import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Required for Line Chart and FlSpot

class LineChartPage extends StatelessWidget {
  final String selectedTimeframe; // 'This Week', 'This Month', or 'This Year'
  final String selectedHabit; // 'Habit 1', 'Habit 2', 'All', etc.

  LineChartPage({
    required this.selectedTimeframe,
    required this.selectedHabit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white, // Make the background white for better contrast
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<FlSpot>>(
          future: _getChartData(selectedTimeframe, selectedHabit),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                  child: Text(
                      "No data available for the selected habit/timeframe"));
            }
            return LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: _getBottomTitles, // X-axis titles
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: _getLeftTitles, // Y-axis titles
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: snapshot.data!, // The spots represent data points
                    isCurved: true,
                    barWidth: 2,
                    color: Colors.blue, // Replace `colors` with `color`
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue
                          .withOpacity(0.2), // Replace `colors` with `color`
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

  // Method to retrieve chart data based on the selected timeframe and habit
  Future<List<FlSpot>> _getChartData(String timeframe, String habit) async {
    List<double> rawData;

    if (habit == 'All') {
      rawData =
          await _getAllHabitData(timeframe); // Aggregate data for all habits
    } else {
      rawData = await _getSpecificHabitData(timeframe, habit);
    }

    return List<FlSpot>.generate(
      rawData.length,
      (index) => FlSpot(index.toDouble(), rawData[index]),
    );
  }

  // Example methods to fetch data from Firestore (replace with your logic)
  Future<List<double>> _getSpecificHabitData(
      String timeframe, String habit) async {
    // Here you would fetch data based on the selected habit and timeframe
    // Mock data: Replace this with your Firestore query
    return [5, 8, 6, 7, 9, 10, 8]; // For "This Week" example
  }

  Future<List<double>> _getAllHabitData(String timeframe) async {
    // Fetch combined data for all habits
    return [10, 12, 11, 15, 14, 13, 16]; // Example for all habits
  }

  // X-axis titles: Adjust this based on the selected timeframe
  Widget _getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 12);
    String text;
    switch (selectedTimeframe) {
      case 'This Week':
        // Map X-axis values to days of the week
        switch (value.toInt()) {
          case 0:
            text = 'Mon';
            break;
          case 1:
            text = 'Tue';
            break;
          case 2:
            text = 'Wed';
            break;
          case 3:
            text = 'Thu';
            break;
          case 4:
            text = 'Fri';
            break;
          case 5:
            text = 'Sat';
            break;
          case 6:
            text = 'Sun';
            break;
          default:
            text = '';
        }
        break;
      case 'This Month':
        // Map X-axis values to weeks of the month
        text = 'Week ${value.toInt() + 1}';
        break;
      case 'This Year':
        // Map X-axis values to months of the year
        text = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec'
        ][value.toInt()];
        break;
      default:
        text = '';
    }
    return SideTitleWidget(
        child: Text(text, style: style), axisSide: meta.axisSide);
  }

  // Y-axis titles: Represent the number of habit completions or streaks
  Widget _getLeftTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 12);
    return SideTitleWidget(
      child: Text(value.toInt().toString(),
          style: style), // Show integer values for the Y-axis
      axisSide: meta.axisSide,
    );
  }
}
