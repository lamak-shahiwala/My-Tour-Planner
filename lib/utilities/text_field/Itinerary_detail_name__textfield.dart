import 'package:flutter/material.dart';

class ItineraryDetailNameTextField extends StatelessWidget {

  final TextEditingController controller;

  const ItineraryDetailNameTextField({super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    const textField_placeholder = TextStyle(
      color: Color(0xFF666666),
      fontFamily: "Sofia_Sans",
      fontWeight: FontWeight.w400,
      fontSize: 20,
    );
    const textFieldStyle = TextStyle(
      color: Color(0xFF000000),
      fontSize: 20,
      fontFamily: "Sofia_Sans",
      fontWeight: FontWeight.w400,
    );
    return TextField(
      controller: controller,
      style: textFieldStyle,
      decoration: InputDecoration(
        labelText: "Enter Detail Name",
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
        enabledBorder: OutlineInputBorder(),
      ),
    );
  }
}