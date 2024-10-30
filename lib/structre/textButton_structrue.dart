import 'package:flutter/material.dart';

class TextButtonStructure extends StatelessWidget {
  final int index;
  final String name;
  final bool isTapped;
  final ValueChanged<int> onTap;

  const TextButtonStructure({
    super.key,
    required this.index,
    required this.name,
    required this.isTapped,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onTap(index);
      },
      style: TextButton.styleFrom(
        minimumSize: const Size(8, 8),
        backgroundColor: isTapped ? Colors.purple : Colors.grey[300],
        foregroundColor:
            isTapped ? Colors.white : const Color.fromARGB(255, 26, 25, 25),
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
          side: BorderSide(
            color: isTapped ? Colors.purple : Colors.grey,
          ),
        ),
      ),
      child: Text(name, style: const TextStyle(fontSize: 16)),
    );
  }
}
