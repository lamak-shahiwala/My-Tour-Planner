import 'package:flutter/material.dart';
import 'package:my_tour_planner/utilities/button/arrow_back_button.dart';
import 'package:my_tour_planner/utilities/button/save_next_button.dart';
import 'package:my_tour_planner/utilities/itinerary_screen_utilities/date_wise_itineraries.dart';
import 'package:my_tour_planner/utilities/text/text_styles.dart';

class CreateItinerary extends StatelessWidget {
  const CreateItinerary({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              ArrowBackButton(),
              SizedBox(height: 30,),
              Align(alignment: Alignment.centerLeft, child: Text("Trip Name", style: heading,)),
              SizedBox(height: 20,),
              DateWiseItineraries(),
              SizedBox(height: 20,),
              SaveNextButton(onPress: (){}, buttonLabel: Text("Save",style: save_next_button,)),
              SizedBox(height: 20,),
            ]
          ),
        )

      ),
    );
  }
}
