import 'package:flutter/material.dart';
import 'package:my_tour_planner/utilities/button/open_street_map_white_search_bar.dart';
import 'package:my_tour_planner/backend/classes.dart';
import 'package:my_tour_planner/backend/database_connection.dart';
import 'package:my_tour_planner/screens/create_trip//create_itinerary.dart';
import 'package:my_tour_planner/utilities/button/arrow_back_button.dart';
import 'package:my_tour_planner/utilities/button/save_next_button.dart';
import 'package:my_tour_planner/utilities/button/white_date_picker_button.dart';
import 'package:my_tour_planner/utilities/text/text_styles.dart';
import 'package:my_tour_planner/utilities/text_field/white_text_field.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateTrip extends StatefulWidget {
  CreateTrip({
    super.key,
  });

  @override
  State<CreateTrip> createState() => _CreateTripState();
}

class _CreateTripState extends State<CreateTrip> {
  final String page_title = "Create your trip Itinerary\nwith us.";

  final trip_db = TripDatabase();
  final tripID = Trip_ID();

  final TextEditingController trip_name = TextEditingController();
  final TextEditingController location = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  String? FormatStartDate;
  String? FormatEndDate;

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
    } else if (startDate != null &&
        startDate!.isAtSameMomentAs(endDatePicked)) {
      setState(() {
        endDate = endDatePicked;
      });
    } else {
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
                    OpenStreetMapWhiteSearchBar(
                        hintText: "Enter Location", controller: location),
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
                        onPress: () async {
                          final supabase = Supabase.instance.client;
                          final user = supabase.auth.currentUser;
                          String? userId = user?.id;

                          if (userId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("User not logged in!")),
                            );
                            return;
                          }

                          if (startDate != null &&
                              endDate != null &&
                              location.text.isNotEmpty &&
                              trip_name.text.isNotEmpty) {
                            final formattedStartDate =
                                DateFormat('yyyy-MM-dd').format(startDate!);
                            final formattedEndDate =
                                DateFormat('yyyy-MM-dd').format(endDate!);

                            final newTrip = Trip(
                              trip_name: trip_name.text,
                              city_location: location.text,
                              start_date: formattedStartDate,
                              end_date: formattedEndDate,
                              user_id: userId,
                            );

                            // Insert Trip and get trip_id
                            final insertedTrip = await supabase
                                .from('Trip')
                                .insert(newTrip.toMap())
                                .select()
                                .single();

                            int tripId = insertedTrip['trip_id'];

                            // Insert itinerary rows (1 per day)
                            final itineraryDb = ItineraryDatabase();

                            for (DateTime date = startDate!;
                                !date.isAfter(endDate!);
                                date = date.add(const Duration(days: 1))) {
                              final formattedDate =
                                  DateFormat('yyyy-MM-dd').format(date);

                              final itinerary = Itinerary(
                                trip_id: tripId,
                                itinerary_date: formattedDate,
                              );

                              await itineraryDb.addItinerary(itinerary);
                            }

                            // Navigate to CreateItinerary screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateItinerary(
                                  startDate: startDate,
                                  endDate: endDate,
                                  trip_name: trip_name.text,
                                  location_name: location.text,
                                  trip_type: "none",
                                  trip_id: tripId,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Please fill all the fields")),
                            );
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
