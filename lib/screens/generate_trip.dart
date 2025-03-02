import 'package:flutter/material.dart';
import 'package:my_tour_planner/api_utilities/open_street_map_white_search_bar.dart';
import 'package:my_tour_planner/screens/itinerary_screen(s)/create_itinerary.dart';
import 'package:my_tour_planner/utilities/button/arrow_back_button.dart';
import 'package:my_tour_planner/utilities/button/save_next_button.dart';
import 'package:my_tour_planner/utilities/button/white_date_picker_button.dart';
import 'package:my_tour_planner/utilities/text/text_styles.dart';
import 'package:my_tour_planner/utilities/text_field/white_text_field.dart';
import 'package:intl/intl.dart';

class GenerateTrip extends StatefulWidget {
  GenerateTrip({super.key,});

  @override
  State<GenerateTrip> createState() => _GenerateTripState();
}

class _GenerateTripState extends State<GenerateTrip> {

  String? selectedValue;
  final types = [
    "Historical",
    "Cultural",
    "Business",
    "Friends",
    "Family",
    "Relaxation",
    "Shopping",
    "Food"
  ]; // for dropdown menu

  final String page_title = "Generate your trip Itinerary.\nProvide details for your\nIdeal Trip.";

  final TextEditingController trip_name = TextEditingController();

  final TextEditingController location = TextEditingController();

  DateTime? startDate;

  DateTime? endDate;

  Future<void> _selectStartDate(BuildContext context) async {
    DateTime? startDatePicked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (startDatePicked == null) return; // Exit if no date is picked

    setState(() {
      startDate = startDatePicked;
    });

    if (endDate != null && startDatePicked.isAfter(endDate!)) {
      setState(() {
        endDate = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Start Date can't be after End Date"),
        duration: Duration(milliseconds: 400),
      ));
    }

    if (endDate != null && startDatePicked.isAtSameMomentAs(endDate!)) {
      setState(() {
        startDate = startDatePicked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    if (startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please select a Start Date first"),
        duration: Duration(milliseconds: 400),
      ));
      return;
    }

    DateTime? endDatePicked = await showDatePicker(
      context: context,
      initialDate: endDate ?? startDate!,
      firstDate: startDate!,
      lastDate: startDate!.add(Duration(days: 365)),
    );

    if (endDatePicked == null) return; // Exit if no date is picked

    if (startDate != null && startDate!.isBefore(endDatePicked)) {
      setState(() {
        endDate = endDatePicked;
      });
    } else if (startDate != null && startDate!.isAtSameMomentAs(endDatePicked)) {
      setState(() {
        endDate = endDatePicked;
      });
    }else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("End Date must be after Start Date"),
        duration: Duration(milliseconds: 400),
      ));
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
                    OpenStreetMapWhiteSearchBar(hintText: "Select Location", controller: location),
                    SizedBox(height: 25,),
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
                    ),                    SizedBox(height: 25,),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Color(0xFFD8DDE3),
                          width: 1.2,
                        ),
                      ),
                      child: DropdownButton<String>(
                        value: selectedValue,
                        hint: Text("Select Trip Type"),
                        isExpanded: true,
                        underline: SizedBox(),
                        style: TextStyle(
                          color: Color(0xFF666666), //Color(0xFF000000),
                          fontSize: 20,
                          fontFamily: "Sofia_Sans",
                          fontWeight: FontWeight.w400,
                        ),
                        // Text styling
                        icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF666666)),
                        // Custom icon
                        dropdownColor: Colors.grey[200],
                        // Background color of dropdown
                        onChanged: (newValue) {
                          setState(() {
                            selectedValue = newValue;
                          });
                        },
                        items: types.map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(type),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 25,),
                    SaveNextButton(onPress: (){
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
                                  trip_type: selectedValue!,)));
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please fill all the fields"),duration: Duration(milliseconds: 400),));
                      }
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
