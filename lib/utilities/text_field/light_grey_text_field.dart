import 'package:flutter/material.dart';
import 'package:my_tour_planner/utilities/text/text_styles.dart';

class LightGreyTextField extends StatelessWidget {
  final String hintText;
  final double topPadding;
  final double bottomPadding;
  final TextEditingController controller;
  final bool obscureText;

  LightGreyTextField({super.key,
    this.topPadding = 0,
    this.bottomPadding = 0,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
  });


  @override
  Widget build(BuildContext context) {
    const textFieldStyle = TextStyle(
      fontSize: 12,
      fontFamily: "Sofia_Sans",
      fontWeight: FontWeight.w500,
    );
    return TextField(
      obscureText: obscureText,
      controller: controller,
      style: textFieldStyle,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: textField_placeholder,
        filled: true,
        fillColor: const Color(0xFFF4F4F4),
          enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Color(0xFFC4C4C4),
            width: .2,
          ),
        ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Color(0xFFF4F4F4),
              width: .2,
            ),
          ),
        ),
      );
  }
}
