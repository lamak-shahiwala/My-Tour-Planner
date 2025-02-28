/*
* White Search Bar
* It is a Stateless Widget rn
* in future: implement focused search bar to dynamically show suggestions..
*/

import 'package:flutter/material.dart';

class GreySearchBar extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  GreySearchBar({
    super.key,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    const textFieldStyle = TextStyle(
      color: Colors.black,
      fontFamily: "Sofia_Sans",
      fontWeight: FontWeight.w400,
      fontSize: 16,
    );
    const textField_placeholder = TextStyle(
      color: Colors.black,
      fontFamily: "Sofia_Sans",
      fontWeight: FontWeight.w400,
      fontSize: 16,
    );

    return Container(
      height: 40,
      width: double.infinity,
      child: SearchBar(
        leading: Icon(Icons.search_rounded, color: Colors.black, size: 20,),
        controller: controller,
        hintText: hintText,
        textStyle: WidgetStatePropertyAll(textFieldStyle),
        backgroundColor: WidgetStateProperty.all(Color.fromRGBO(211, 211, 211, 1)),
        hintStyle: WidgetStatePropertyAll(textField_placeholder),
        side: WidgetStateProperty.all(BorderSide(
          color: Color.fromRGBO(211, 211, 211, 1),
          width: 1.2,
        )),
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        elevation: WidgetStateProperty.all(1),

      ),
    );
  }
}
