/*

This Code is rn under development

 */



import 'package:flutter/material.dart';

class ItineraryDetailNameTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const ItineraryDetailNameTextField({
    super.key,
    required this.labelText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    const textField_placeholder = TextStyle(
      color: Color(0xFF666666),
      fontFamily: "Sofia_Sans",
      fontWeight: FontWeight.w400,
      fontSize: 18,
    );
    const textFieldStyle = TextStyle(
      color: Color(0xFF000000),
      fontSize: 18,
      fontFamily: "Sofia_Sans",
      fontWeight: FontWeight.w400,
    );
    return Expanded(
      child: TextField(
        controller: controller,
        style: textFieldStyle,
        decoration: InputDecoration(
          
          labelText: labelText,
          labelStyle: textField_placeholder,
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
      ),
    );
  }
}
