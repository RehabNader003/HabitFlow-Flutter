// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

class MonthlyView extends StatefulWidget {
  final Function(List<DateTime?>) onDatesSelected;

  const MonthlyView({super.key, required this.onDatesSelected});

  @override
  _MonthlyViewState createState() => _MonthlyViewState();
}

class _MonthlyViewState extends State<MonthlyView> {
  List<DateTime?> _selectedDates = [];
  String dynamicText = "";

  String _generateDynamicText(List<DateTime?> dates) {
    List<String> dayNumbers =
        dates.map((date) => date?.day.toString() ?? '').toList();
    return 'Every month on ${dayNumbers.join(', ')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(7.0),
          child: Text(dynamicText,
              style: TextStyle(fontSize: 16, color: Colors.grey[700])),
        ),
        const Divider(),
        CalendarDatePicker2(
          value: _selectedDates,
          config: CalendarDatePicker2Config(
            calendarType: CalendarDatePicker2Type.multi,
            selectedDayHighlightColor: Colors.purple,
            weekdayLabels: ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'],
          ),
          onValueChanged: (dates) {
            setState(() {
              _selectedDates = dates;
              dynamicText = _generateDynamicText(_selectedDates);
              widget.onDatesSelected(_selectedDates);
            });
          },
        ),
      ],
    );
  }
}
