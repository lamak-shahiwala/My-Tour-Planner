/*
* White Search Bar
* It is a Stateless Widget rn
* in future: implement focused search bar to dynamically show suggestions..
*/

import 'package:flutter/material.dart';

class WhiteSearchBar extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  WhiteSearchBar({
    super.key,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    const textFieldStyle = TextStyle(
      color: Color(0xFF666666), //Color(0xFF000000),
      fontSize: 20,
      fontFamily: "Sofia_Sans",
      fontWeight: FontWeight.w400,
    );
    const textField_placeholder = TextStyle(
      color: Color(0xFF666666),
      fontFamily: "Sofia_Sans",
      fontWeight: FontWeight.w400,
      fontSize: 20,
    );

    return SearchBar(
      controller: controller,
      hintText: hintText,
      textStyle: WidgetStatePropertyAll(textFieldStyle),
      backgroundColor: WidgetStateProperty.all(Colors.white),
      hintStyle: WidgetStatePropertyAll(textField_placeholder),
      side: WidgetStateProperty.all(BorderSide(
        color: Color(0xFFD8DDE3),
        width: 1.2,
      )),
      shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
      elevation: WidgetStateProperty.all(0),
      trailing: [
        Icon(Icons.location_pin, color: Color(0xFF0097B2),),
      ],
    );
  }
}
