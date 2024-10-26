import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'line_titles.dart';

class LineChartWidget extends StatelessWidget {
  final List<FlSpot> data;

  LineChartWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    // Calculate minY and maxY dynamically based on data
    double minY = data.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
    double maxY = data.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);

    double yPadding = (maxY - minY) * 0.1;
    minY -= yPadding;
    maxY += yPadding;

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: data.length.toDouble() - 1,
        minY: minY,
        maxY: maxY,
        backgroundColor: Colors.white, // Set the chart background to white
        titlesData: LineTitles.getTitleData(),
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: const Color(0xffA29B9B),
              strokeWidth: 1,
            );
          },
          drawVerticalLine: true,
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: const Color(0xffA29B9B),
              strokeWidth: 1,
            );
          },
        ),
        lineBarsData: [
          LineChartBarData(
            spots: data,
            isCurved: true,
            color: const Color(0xff8C86F0),
            barWidth: 5,
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xffE8E6FB),
            ),
          ),
        ],
      ),
    );
  }
}
