// Incomplete...

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_tour_planner/utilities/button/save_next_button.dart';
import 'package:my_tour_planner/utilities/itinerary_screen_utilities/dynamic_itinerary_details.dart';
import 'package:my_tour_planner/utilities/text/text_styles.dart';
class DateWiseItineraries extends StatefulWidget {

  DateTime? startDate;
  DateTime? endDate;
  DateTime? selectedDate;
  @override
  _DateWiseItinerariesState createState() => _DateWiseItinerariesState();
}

class _DateWiseItinerariesState extends State<DateWiseItineraries> {

  List<DateTime> dateList = [];

  // Function to pick a date
  Future<DateTime?> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    return await showDatePicker(
      context: context,
      initialDate: widget.selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(Duration(days: 365)),
    );
  }

  // Function to generate dates and create TextControllers
  void generateDateFields() {
    if (widget.startDate != null && widget.endDate != null && widget.startDate!.isBefore(widget.endDate!)) {
      setState(() {
        dateList.clear();
        for (DateTime date = widget.startDate!;
        date.isBefore(widget.endDate!.add(Duration(days: 1)));
        date = date.add(Duration(days: 1))) {
          dateList.add(date);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    DateTime? picked = await _selectDate(context);
                    if (picked != null) {
                      setState(() {
                        widget.startDate = picked;
                      });
                      generateDateFields();
                    }
                  },
                  child: Text(widget.startDate == null
                      ? "Start Date"
                      : DateFormat("dd MMM yyyy").format(widget.startDate!)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? picked = await _selectDate(context);
                    if (picked != null) {
                      setState(() {
                        widget.endDate = picked;
                      });
                      generateDateFields();
                    }
                  },
                  child: Text(widget.endDate == null
                      ? "Select End Date"
                      : DateFormat("dd MMM yyyy").format(widget.endDate!)),
                ),
              ],
            ),
            SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: dateList.length,
              itemBuilder: (context, index) {
                DateTime date = dateList[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(child: Text("Date: "+DateFormat("dd MMM yyyy").format(date), style: date_heading,),alignment: Alignment.centerLeft,),
                    DynamicItineraryDetails(),
                    SizedBox(height: 10,),
                  ],
                );
              },
            ),
          ],
        ),
    );
  }
}