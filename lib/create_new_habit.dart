// ignore_for_file: library_private_types_in_public_api

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:project_app/HomePage.dart';
import 'package:project_app/today.dart';
import 'daily_view.dart';
import 'monthly_view.dart';
import 'saveData.dart';
import 'styles.dart';
import 'textField_structrue.dart';

class CreateHabitScreen extends StatefulWidget {
  final String? taskId;
  final String? taskName;
  final Color? taskColor;
  final String? taskDescription;
  final String? habitId;
  final Map<String, dynamic>? habitData;

  const CreateHabitScreen(
      {super.key,
      this.habitId,
      this.habitData,
      this.taskId,
      this.taskName,
      this.taskColor,
      this.taskDescription});

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

  String? habitName;
  String? description;
  Color? color;
  String? repeatSchedule;
  bool? reminder;

  TextEditingController nameController = TextEditingController();
  TextEditingController disController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // If editing, pre-fill form with existing habit data
    if (widget.habitData != null) {
      nameController.text = widget.habitData!['habitName'] ?? '';
      disController.text = widget.habitData!['description'] ?? '';
      screenPickerColor = Color(widget.habitData!['color'] ?? 0xFFFFFFFF);
      _selectedDays = List<int>.from(widget.habitData!['selectedDays'] ?? []);
      _selectedDates =
          List<DateTime?>.from(widget.habitData!['selectedDates'] ?? []);
      reminderEnabled = widget.habitData!['reminderEnabled'] ?? false;
      if (widget.habitData!['reminderTime'] != null) {
        reminderTime =
            TimeOfDay.fromDateTime(widget.habitData!['reminderTime'].toDate());
      }
    }
  }

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
    // Pre-fill controllers with passed data if available
    if (habitName != null) {
      nameController.text = habitName!;
    }
    if (description != null) {
      disController.text = description!;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habitId != null ? 'Edit Habit' : 'Create New Habit'),
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
                        // Save or Update Habit
                        if (widget.habitId != null) {
                          // Update existing habit
                          HabitService.updateHabitInFirestore(
                            habitId: widget.habitId!,
                            habitName: nameController.text,
                            habitDescription: disController.text,
                            isDaily: currentPage == 0,
                            isMonthly: currentPage == 1,
                            color: screenPickerColor,
                            selectedDates: _selectedDates,
                            selectedDays: _selectedDays,
                            reminderEnabled: reminderEnabled,
                            reminderTime: reminderTime,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Habit updated successfully.")),
                          );
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const Today()));
                        } else {
                          // Create new habit
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
                                content: Text("Habit created successfully.")),
                          );
                        }
                        // Navigate back to weekly screen
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const HomePage()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Please fill in all fields.")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8985E9),
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
