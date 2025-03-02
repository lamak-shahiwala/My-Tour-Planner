/*
* things to do: store start date and end date in a var
*
**/

import 'package:flutter/material.dart';
import 'package:my_tour_planner/api_utilities/open_street_map_white_search_bar';
import 'package:my_tour_planner/api_utilities/open_street_map_white_search_bar.dart';
import 'package:my_tour_planner/screens/itinerary_screen(s)/create_itinerary.dart';
import 'package:my_tour_planner/utilities/button/arrow_back_button.dart';
import 'package:my_tour_planner/utilities/button/save_next_button.dart';
import 'package:my_tour_planner/utilities/button/white_date_picker_button.dart';
import 'package:my_tour_planner/utilities/text/text_styles.dart';
import 'package:my_tour_planner/utilities/text_field/white_text_field.dart';
import 'package:intl/intl.dart';

class CreateTrip extends StatefulWidget {
  CreateTrip({
    super.key,
  });

  @override
  State<CreateTrip> createState() => _CreateTripState();
}

class _CreateTripState extends State<CreateTrip> {
  final String page_title = "Create your trip Itinerary\nwith us.";

  final TextEditingController trip_name = TextEditingController();

  final TextEditingController location = TextEditingController();

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
    if (startDate!.isAfter(endDate!)) {
      setState(() {
        endDate = null;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Start Date can't be after End Date"),
          duration: Duration(milliseconds: 400),
        ));
      });
    }
    if (startDatePicked != null &&
        startDatePicked != startDate &&
        endDate!.isAtSameMomentAs(startDatePicked)) {
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

    if (endDatePicked != null &&
        endDatePicked != endDate &&
        startDate != null &&
        startDate!.isBefore(endDatePicked)) {
      setState(() {
        endDate = endDatePicked;
      });
    } else {
      endDate = null;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Start Date can't be after End Date"),
        duration: Duration(milliseconds: 400),
      ));
    }
    if (endDatePicked != null &&
        endDatePicked != endDate &&
        startDate != null &&
        startDate!.isAtSameMomentAs(endDatePicked)) {
      setState(() {
        endDate = endDatePicked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              ArrowBackButton(),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      page_title,
                      style: sub_heading,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    WhiteTextField(
                        labelText: "Enter Trip Name", controller: trip_name),
                    SizedBox(
                      height: 40,
                    ),
                    OpenStreetMapWhiteSearchBar(hintText: "Enter Location", controller: location),
                    //WhiteSearchBar(hintText: "Select Location", controller: location),
                    SizedBox(
                      height: 40,
                    ),
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
                    SizedBox(
                      height: 30,
                    ),
                    SaveNextButton(
                        onPress: () {
                          if (startDate != null &&
                              endDate != null &&
                              location.text.isNotEmpty &&
                              trip_name.text.isNotEmpty) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreateItinerary(
                                          start_Date: startDate,
                                          end_Date: endDate,
                                          trip_name: trip_name.text,
                                          location_name: location.text,
                                          trip_type: "none",
                                        )));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Please fill all the fields"),
                              duration: Duration(milliseconds: 400),
                            ));
                          }
                        },
                        buttonLabel: Text(
                          "Next",
                          style: save_next_button,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
