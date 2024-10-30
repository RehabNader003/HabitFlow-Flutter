// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ElevatedbuttonStructrue extends StatelessWidget {
  PageController controller = PageController();
  int currentPage;
  String title;
  int index;
  ElevatedbuttonStructrue(
      {super.key,
      required this.controller,
      required this.currentPage,
      required this.title,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        controller.animateToPage(0,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            currentPage == index ? Colors.purple : Colors.grey[200],
        foregroundColor: currentPage == index ? Colors.white : Colors.black,
      ),
      child: Text(title),
    );
  }
}
