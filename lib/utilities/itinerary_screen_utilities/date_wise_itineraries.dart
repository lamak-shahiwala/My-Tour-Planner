// Incomplete...

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_tour_planner/utilities/itinerary_screen_utilities/dynamic_itinerary_details.dart';
import 'package:my_tour_planner/utilities/text/text_styles.dart';
class DateWiseItineraries extends StatefulWidget {

  DateWiseItineraries({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  final DateTime? startDate;
  final DateTime? endDate;
  @override
  _DateWiseItinerariesState createState() => _DateWiseItinerariesState();
}

class _DateWiseItinerariesState extends State<DateWiseItineraries> {

  List<DateTime> dateList = [];


  @override
  void initState() {
    super.initState();
    generateDateFields();
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
    if (widget.startDate != null && widget.endDate != null && widget.startDate!.isAtSameMomentAs(widget.endDate!)) {
      setState(() {
        dateList.clear();
        dateList.add(widget.startDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          children: [
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