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
      fontSize: 20,
    );
    const textFieldStyle = TextStyle(
      color: Color(0xFF000000),
      fontSize: 20,
      fontFamily: "Sofia_Sans",
      fontWeight: FontWeight.w400,
    );
    return Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 50, // Ensures initial height is small
            maxHeight: 300, // Prevents excessive expansion
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
              border: OutlineInputBorder(),
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
