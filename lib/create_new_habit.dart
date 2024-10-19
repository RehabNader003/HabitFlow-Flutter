// ignore_for_file: library_private_types_in_public_api

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:project_app/daily_view.dart';
import 'package:project_app/monthly_view.dart';
import 'package:project_app/saveData.dart';
import 'package:project_app/styles.dart';
import 'package:project_app/textField_structrue.dart';

class CreateHabitScreen extends StatefulWidget {
  const CreateHabitScreen({super.key});

  @override
  _CreateHabitScreenState createState() => _CreateHabitScreenState();
}

class _CreateHabitScreenState extends State<CreateHabitScreen> {
  bool isOneTimeTask = false;
  bool isAllDay = true;
  bool reminderEnabled = false;
  TimeOfDay? reminderTime;
  bool endHabitEnabled = false;
  Color screenPickerColor = Colors.blue;
  PageController pageController = PageController();
  int currentPage = 0;
  List<DateTime?> _selectedDates = [];
  List<int> _selectedDays = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController disController = TextEditingController();

  @override
  void dispose() {
    pageController.dispose();
    nameController.dispose();
    disController.dispose();
    super.dispose();
  }

  void _updateSelectedDates(List<DateTime?> dates) {
    setState(() {
      _selectedDates = dates;
    });
  }

  void _updateSelectedDays(List<int> days) {
    setState(() {
      _selectedDays = days;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Habit'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back when close is pressed
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextfieldStructrue(
                controller: nameController,
                hintText: "Habit Name",
                labelText: "Habit Name",
              ),
              const SizedBox(height: 10),
              TextfieldStructrue(
                controller: disController,
                hintText: "Habit Description",
                labelText: "Habit Description",
              ),
              const SizedBox(height: 16),
              Text(
                "Color",
                style: textStyle,
              ),
              ColorPicker(
                spacing: 8,
                columnSpacing: 0,
                pickersEnabled: const <ColorPickerType, bool>{
                  ColorPickerType.accent: false
                },
                enableShadesSelection: false,
                color: screenPickerColor,
                onColorChanged: (Color color) =>
                    setState(() => screenPickerColor = color),
                borderRadius: 20,
              ),
              const SizedBox(height: 16),
              Text(
                'Repeat',
                style: textStyle,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      pageController.animateToPage(0,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.easeInOut);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          currentPage == 0 ? Colors.purple : Colors.grey[200],
                      foregroundColor:
                          currentPage == 0 ? Colors.white : Colors.black,
                    ),
                    child: const Text('Daily'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      pageController.animateToPage(1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          currentPage == 1 ? Colors.purple : Colors.grey[200],
                      foregroundColor:
                          currentPage == 1 ? Colors.white : Colors.black,
                    ),
                    child: const Text('Monthly'),
                  ),
                ],
              ),
              SizedBox(
                height: currentPage == 0 ? 280 : 400,
                child: PageView(
                  controller: pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      currentPage = page;
                    });
                  },
                  children: [
                    DailyView(
                      onDaysSelected: _updateSelectedDays,
                      reminderState: (bool enabled, TimeOfDay? time) {
                        setState(
                          () {
                            reminderEnabled = enabled;
                            reminderTime = time;
                          },
                        );
                      },
                    ),
                    MonthlyView(onDatesSelected: _updateSelectedDates),
                  ],
                ),
              ),
              Center(
                child: SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isNotEmpty) {
                        if (currentPage == 1 && _selectedDates.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Please select at least one date.")),
                          );
                          return;
                        }
                        if (currentPage == 0 && _selectedDays.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Please select at least one day.")),
                          );
                          return;
                        }

                        HabitService.saveHabitToFirestore(
                            habitName: nameController.text,
                            habitDescription: disController.text,
                            isDaily: currentPage == 0,
                            isMonthly: currentPage == 1,
                            color: screenPickerColor,
                            selectedDates: _selectedDates,
                            selectedDays: _selectedDays,
                            reminderEnabled: reminderEnabled,
                            reminderTime: reminderTime);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Your Habit added sucssefully.")),
                        );
                        // Navigator.of(context).pushReplacement(MaterialPageRoute(
                        //     builder: (context) => const HomePage()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Please fill name habit fields.")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
