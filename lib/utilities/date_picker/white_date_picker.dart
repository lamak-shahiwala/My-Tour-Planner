import 'package:flutter/material.dart';
import 'package:my_tour_planner/utilities/button/white_date_picker_button.dart';
import 'package:intl/intl.dart';

class WhiteDatePicker extends StatefulWidget {
  final String datePicker_Label;
  const WhiteDatePicker({Key? key, required this.datePicker_Label}) : super(key: key);
  @override
  _WhiteDatePickerState createState() => _WhiteDatePickerState();
}

class _WhiteDatePickerState extends State<WhiteDatePicker> {
  DateTime? _selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WhiteDatePicker_button(
          onPress: () => _selectDate(context),
          buttonLabel: Text(
            _selectedDate == null
                ? widget.datePicker_Label
                : "${DateFormat.yMMMMd().format(_selectedDate ?? DateTime.now())}",
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: 20,
              fontFamily: "Sofia_Sans",
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}