import 'package:flutter/material.dart';
import 'package:my_tour_planner/utilities/button/arrow_back_button.dart';
import 'package:my_tour_planner/utilities/itinerary_screen_utilities/dynamic_things_to_carry.dart';
import 'package:my_tour_planner/utilities/text/text_styles.dart';

class AddThingsToCarry extends StatelessWidget {
  AddThingsToCarry(
      {super.key,
        required this.trip_name,
        required this.location_name,
        required this.trip_type});

  final String trip_name;
  final String location_name;
  final String trip_type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        child: Expanded(child: DynamicThingsToCarry()),
      ),
    );
  }
}
