/*

This Code is rn under development

 */


import 'package:flutter/material.dart';
import 'package:my_tour_planner/utilities/button/white_time_picker_button.dart';

class WhiteTimePicker extends StatefulWidget {
  @override
  _WhiteTimePickerState createState() => _WhiteTimePickerState();
}

class _WhiteTimePickerState extends State<WhiteTimePicker> {
  String selected_time = "00:00";

  Future<void> selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 0, minute: 0),
      initialEntryMode: TimePickerEntryMode.inputOnly,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        selected_time = pickedTime.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WhiteTimePickerButton(
        onPress: () {
          selectTime(context);
          setState(() {
            Text(selected_time);
          });
        },
        buttonLabel: Text(selected_time, style: TextStyle(
          color: Color(0xFF666666),
          fontFamily: "Sofia_Sans",
          fontWeight: FontWeight.w400,
          fontSize: 18,
        ),));
  }
}
