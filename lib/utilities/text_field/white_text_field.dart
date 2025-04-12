import 'package:flutter/material.dart';

class WhiteTextField extends StatelessWidget {
  final String labelText;
  final double topPadding;
  final double bottomPadding;
  final TextEditingController controller;

  const WhiteTextField({super.key,
    this.topPadding = 0,
    this.bottomPadding = 0,
    required this.labelText,
    required this.controller,
  });


  @override
  Widget build(BuildContext context) {
    const textFieldStyle = TextStyle(
      color: Color(0xFF666666), //Color(0xFF000000),
      fontSize: 16,
      fontFamily: "Sofia_Sans",
      fontWeight: FontWeight.w400,
    );
    const textField_placeholder = TextStyle(
      color: Color(0xFF666666),
      fontFamily: "Sofia_Sans",
      fontWeight: FontWeight.w400,
      fontSize: 16,
    );

    return TextField(
      controller: controller,
      style: textFieldStyle,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: textField_placeholder,
        filled: true,
        fillColor: Color.fromRGBO(255, 255, 255, 1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Color(0xFFD8DDE3),
            width: 1.2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Color(0xFFD8DDE3),
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Color(0xFFD8DDE3),
            width: 1.2,
          ),
        ),
      ),
    );
  }
}
