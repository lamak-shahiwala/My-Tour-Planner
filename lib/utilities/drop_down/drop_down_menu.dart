import 'package:flutter/material.dart';

class DropDownMenu extends StatefulWidget {
  DropDownMenu({super.key});

  @override
  State<DropDownMenu> createState() => _DropDownMenuState();
}

class _DropDownMenuState extends State<DropDownMenu> {
  String? selectedValue;
  final types = [
    "Historical",
    "Cultural",
    "Business",
    "Friends",
    "Family",
    "Relaxation",
    "Shopping",
    "Food"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Color(0xFFD8DDE3),
          width: 1.2,
        ),
      ),
      child: DropdownButton<String>(
        value: selectedValue,
        hint: Text("Select Trip Type"),
        isExpanded: true,
        underline: SizedBox(),
        style: TextStyle(
          color: Color(0xFF666666), //Color(0xFF000000),
          fontSize: 20,
          fontFamily: "Sofia_Sans",
          fontWeight: FontWeight.w400,
        ),
        // Text styling
        icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF666666)),
        // Custom icon
        dropdownColor: Colors.grey[200],
        // Background color of dropdown
        onChanged: (newValue) {
          setState(() {
            selectedValue = newValue;
          });
        },
        items: types.map((type) {
          return DropdownMenuItem<String>(
            value: type,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(type),
            ),
          );
        }).toList(),
      ),
    );
  }
}
