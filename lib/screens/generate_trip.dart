/*
* things to do: store start date and end date in a var
*
**/

import 'package:flutter/material.dart';
import 'package:my_tour_planner/utilities/button/arrow_back_button.dart';
import 'package:my_tour_planner/utilities/button/save_next_button.dart';
import 'package:my_tour_planner/utilities/date_picker/white_date_picker.dart';
import 'package:my_tour_planner/utilities/drop_down/drop_down_menu.dart';
import 'package:my_tour_planner/utilities/search_bar/white_search_bar.dart';
import 'package:my_tour_planner/utilities/text/text_styles.dart';
import 'package:my_tour_planner/utilities/text_field/white_text_field.dart';

class GenerateTrip extends StatelessWidget {
  GenerateTrip({super.key, this.start_date, this.end_date});

  final String page_title = "Generate your trip Itinerary.\nProvide details for your\nIdeal Trip.";
  final TextEditingController trip_name = TextEditingController();
  final TextEditingController location = TextEditingController();

  final DateTime? start_date;
  final DateTime? end_date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              ArrowBackButton(),
              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(page_title, style: sub_heading, textAlign: TextAlign.center,),
                    SizedBox(height: 40,),
                    WhiteTextField(labelText: "Enter Trip Name", controller: trip_name),
                    SizedBox(height: 25,),
                    WhiteSearchBar(hintText: "Select Location", controller: location),
                    SizedBox(height: 25,),
                    WhiteDatePicker(),
                    SizedBox(height: 25,),
                    DropDownMenu(),
                    SizedBox(height: 25,),
                    SaveNextButton(onPress: (){

                    }, buttonLabel: Text("Next",style: save_next_button,)),
                  ],
                ),
              ),

            ],),
        ),
      ),
    );
  }
}
