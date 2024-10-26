import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineTitles {
  static getTitleData() => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            getTitlesWidget: (value, meta) {
              const style = TextStyle(
                color: Color(0xff68737d),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              );
              Widget text;
              switch (value.toInt()) {
                case 2:
                  text = const Text('MAR', style: style);
                  break;
                case 5:
                  text = const Text('JUN', style: style);
                  break;
                case 8:
                  text = const Text('SEP', style: style);
                  break;
                default:
                  text = const Text('');
                  break;
              }
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 8,
                child: text,
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            getTitlesWidget: (value, meta) {
              const style = TextStyle(
                color: Color(0xff67727d),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              );
              Widget text;
              switch (value.toInt()) {
                case 1:
                  text = const Text('10k', style: style);
                  break;
                case 3:
                  text = const Text('30k', style: style);
                  break;
                case 5:
                  text = const Text('50k', style: style);
                  break;
                default:
                  text = const Text('');
                  break;
              }
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 12,
                child: text,
              );
            },
          ),
        ),
      );
}
