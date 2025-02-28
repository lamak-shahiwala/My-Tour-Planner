import 'package:flutter/material.dart';
import 'package:my_tour_planner/utilities/button/arrow_back_button.dart';
import 'package:my_tour_planner/utilities/button/save_next_button.dart';
import 'package:my_tour_planner/utilities/itinerary_screen_utilities/date_wise_itineraries.dart';
import 'package:my_tour_planner/utilities/text/text_styles.dart';

class CreateItinerary extends StatelessWidget {
  CreateItinerary(
      {super.key,
      required this.start_Date,
      required this.end_Date,
      required this.trip_name,
      required this.location_name});

  final DateTime? start_Date;
  final DateTime? end_Date;
  final String trip_name;
  final String location_name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 140,
        title: Column(
              children: [
                Align(alignment: Alignment.topLeft ,child: ArrowBackButton()),
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      trip_name,
                      style: heading,
                    )),
                Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          location_name,
                          style: location,
                        ),
                        Icon(
                          Icons.location_pin,
                          color: Color.fromRGBO(178, 60, 50, 1),
                          size: 18,
                        )
                      ],
                    )),
              ],
            ),
        ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          DateWiseItineraries(startDate: start_Date, endDate: end_Date),
          SizedBox(
            height: 20,
          ),
          SaveNextButton(
              onPress: () {},
              buttonLabel: Text(
                "Save",
                style: save_next_button,
              )),
          SizedBox(
            height: 20,
          ),
        ]),
      )),
    );
  }
}
