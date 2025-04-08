
/*

This Code is rn under development

 */

import 'package:flutter/material.dart';


class ExpandableCustomItineraryNoteTextField extends StatefulWidget {
  final TextEditingController controller;

  const ExpandableCustomItineraryNoteTextField({
    super.key,
    required this.controller,
  });

  @override
  State<ExpandableCustomItineraryNoteTextField> createState() =>
      _ExpandableCustomItineraryNoteTextFieldState();
}

class _ExpandableCustomItineraryNoteTextFieldState
    extends State<ExpandableCustomItineraryNoteTextField> {
  @override
  Widget build(BuildContext context) {
    const textField_placeholder = TextStyle(
      color: Color(0xFF666666),
      fontFamily: "Sofia_Sans",
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );
    const textFieldStyle = TextStyle(
      color: Color(0xFF000000),
      fontSize: 14,
      fontFamily: "Sofia_Sans",
      fontWeight: FontWeight.w400,
    );
    return Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 50, // Ensures initial height is small
            maxHeight: 150, // Prevents excessive expansion
          ),
          child: TextField(
            controller: widget.controller,
            minLines: 1,
            maxLines: null,
            style: textFieldStyle,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              labelText: "Custom Note",
              labelStyle: textField_placeholder,
              hintText: "Note....",
              hintStyle: textField_placeholder,
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
            onChanged: (text) {
              setState(() {}); // Forces rebuild for dynamic height
            },
          ),
        ),
      ],
    );
  }
}
