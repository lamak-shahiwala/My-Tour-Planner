import 'package:flutter/material.dart';
import 'package:my_tour_planner/screens/create_trip.dart';
import 'package:my_tour_planner/utilities/button/white_date_picker_button.dart';
import 'package:intl/intl.dart';

class WhiteDatePicker extends StatefulWidget {

  @override
  _WhiteDatePickerState createState() => _WhiteDatePickerState();
}

class _WhiteDatePickerState extends State<WhiteDatePicker> {

  DateTime? startDate;
  DateTime? endDate;

  Future<void> _selectStartDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime? startDatePicked = await showDatePicker(
      context: context,
      initialDate: startDate ?? now,
      firstDate: now,
      lastDate: now.add(Duration(days: 365)),
    );
    if (startDatePicked != null && startDatePicked != startDate) {
      setState(() {
        startDate = startDatePicked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime? endDatePicked = await showDatePicker(
      context: context,
      initialDate: endDate ?? now,
      firstDate: now,
      lastDate: now.add(Duration(days: 365)),
    );

    if (endDatePicked != null && endDatePicked != endDate && startDate!.isBefore(endDatePicked) && startDate !=null) {
      setState(() {
        endDate = endDatePicked;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateTrip(end_date: endDate, start_date: startDate,),
          ),
        );
      });
    }else{
      endDate = null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please choose the start date and end date correctly.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            WhiteDatePicker_button(
              onPress: () => _selectStartDate(context),
              buttonLabel: Text(
                startDate == null
                    ? "Start Date"
                    : "${DateFormat("dd MMM, y").format(startDate ?? DateTime.now())}",
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 18,
                  fontFamily: "Sofia_Sans",
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            WhiteDatePicker_button(
              onPress: () => _selectEndDate(context),
              buttonLabel: Text(
                endDate == null
                    ? "End Date"
                    : "${DateFormat("dd MMM, y").format(endDate ?? DateTime.now())}",
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 18,
                  fontFamily: "Sofia_Sans",
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
