import 'package:flutter/material.dart';
import 'package:my_tour_planner/utilities/button/white_date_picker_button.dart';
import 'package:intl/intl.dart';

class WhiteDatePicker extends StatefulWidget {
  final String datePicker_Label;
  DateTime? selectedDate;

  WhiteDatePicker({super.key,
    required this.datePicker_Label,
    required this.selectedDate,
  });

  @override
  _WhiteDatePickerState createState() => _WhiteDatePickerState();
}

class _WhiteDatePickerState extends State<WhiteDatePicker> {
  Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(Duration(days: 365)),
    );
    if (picked != null && picked != widget.selectedDate) {
      setState(() {
        widget.selectedDate = picked;
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
            widget.selectedDate == null
                ? widget.datePicker_Label
                : "${DateFormat("dd MMM, y").format(widget.selectedDate ?? DateTime.now())}",
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: 18,
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
