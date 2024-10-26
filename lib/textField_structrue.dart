import 'package:flutter/material.dart';
import 'package:project_app/styles.dart';

// ignore: must_be_immutable
class TextfieldStructrue extends StatelessWidget {
  TextfieldStructrue(
      {super.key, this.hintText, this.labelText, required this.controller});
  String? hintText;
  String? labelText;

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6, left: 5),
          child: Text(
            "$labelText",
            style: textStyle,
          ),
        ),
        TextField(
          onChanged: (val) {
            hintText = val;
            print(val);
          },
          controller: controller,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: hintStyle,
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(color: Color.fromARGB(255, 179, 179, 179)),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(color: Color.fromARGB(255, 179, 179, 179)),
            ),
          ),
        )
      ],
    );
  }
}
