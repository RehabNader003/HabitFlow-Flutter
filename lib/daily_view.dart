import 'package:flutter/material.dart';
import 'package:project_app/styles.dart';

class DailyView extends StatefulWidget {
  final Function(bool, TimeOfDay?) reminderState;
  final Function(List<int>) onDaysSelected;

  const DailyView(
      {super.key, required this.onDaysSelected, required this.reminderState});

  @override
  State<DailyView> createState() => _DailyViewState();
}

class _DailyViewState extends State<DailyView> {
  bool isAllDay = false;
  bool reminderEnabled = false;
  List<bool> isDayTapped = List.generate(7, (_) => false);
  TimeOfDay selectedTime = TimeOfDay.now();

  void toggleDay(int index) {
    setState(() {
      isDayTapped[index] = !isDayTapped[index];
      _updateSelectedDays();
    });
  }

  void _updateSelectedDays() {
    List<int> selectedDays = [];
    for (int i = 0; i < isDayTapped.length; i++) {
      if (isDayTapped[i]) {
        selectedDays.add(i + 1);
      }
    }
    widget.onDaysSelected(selectedDays);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;

        widget.reminderState(
            reminderEnabled, reminderEnabled ? selectedTime : null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'On these days:',
              style: textStyle,
            ),
            Checkbox(
              activeColor: Colors.purple,
              value: isAllDay,
              onChanged: (bool? value) {
                setState(() {
                  isAllDay = value!;
                  isDayTapped = List.generate(7, (_) => isAllDay);
                  _updateSelectedDays();
                });
              },
            ),
          ],
        ),
        // Days Section
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ...List.generate(7, (index) {
              String day = ['S', 'M', 'T', 'W', 'T', 'F', 'S'][index];
              return TextButton(
                onPressed: () => toggleDay(index),
                style: TextButton.styleFrom(
                  minimumSize: const Size(10, 10),
                  backgroundColor:
                      isDayTapped[index] ? Colors.purple : Colors.white,
                  foregroundColor:
                      isDayTapped[index] ? Colors.white : Colors.black,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                        color:
                            isDayTapped[index] ? Colors.purple : Colors.grey),
                  ),
                ),
                child: Text(day, style: const TextStyle(fontSize: 16)),
              );
            }),
          ],
        ),
        // Set Reminder

        const SizedBox(
          height: 16,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Set Reminder', style: textStyle),
            Switch(
              value: reminderEnabled,
              onChanged: (bool value) {
                setState(() {
                  reminderEnabled = value;
                  widget.reminderState(
                      reminderEnabled, reminderEnabled ? selectedTime : null);
                });
              },
            ),
          ],
        ),
        // Show selected time and edit option if reminder is enabled
        if (reminderEnabled)
          GestureDetector(
            onTap: () => _selectTime(context),
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.purple),
                      const SizedBox(width: 8),
                      Text(selectedTime.format(context)),
                    ],
                  ),
                  const Icon(Icons.edit, color: Colors.purple), // Edit icon
                ],
              ),
            ),
          ),
      ],
    );
  }
}
