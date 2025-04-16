import 'package:flutter/material.dart';
import 'package:my_tour_planner/utilities/text_field/open_street_map_white_search_bar.dart';
import 'package:my_tour_planner/backend/classes.dart';
import 'package:my_tour_planner/backend/db_methods.dart';
import 'package:my_tour_planner/screens/create_trip//create_itinerary.dart';
import 'package:my_tour_planner/utilities/button/arrow_back_button.dart';
import 'package:my_tour_planner/utilities/button/save_next_button.dart';
import 'package:my_tour_planner/utilities/button/white_date_picker_button.dart';
import 'package:my_tour_planner/utilities/image_picker/template_cover_picker.dart';
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

  String? selectedValue;
  TextEditingController minController = TextEditingController();
  TextEditingController maxController = TextEditingController();
  String? customRange;
  final List<String> budgetRange = [
    "Enter Custom Range",
    "Below ₹1,000",
    "₹1,000 - ₹2,500",
    "₹2,500 - ₹5,000",
    "₹5,000 - ₹10,000",
    "₹10,000 - ₹15,000",
    "₹15,000 - ₹20,000",
    "₹20,000 - ₹30,000",
    "₹30,000 - ₹50,000",
    "₹50,000 - ₹75,000",
    "₹75,000 - ₹1,00,000",
    "₹1,00,000 - ₹1,25,000",
    "₹1,25,000 - ₹1,50,000",
    "Above ₹1,50,000",
  ];

  DateTime? startDate;
  DateTime? endDate;

  String? _imageUrl;

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

  String? _getSelectedBudget() {
    if (selectedValue == "Enter Custom Range") {
      return customRange;
    } else {
      return selectedValue;
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: ArrowBackButton(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      page_title,
                      style: sub_heading,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TemplateCoverPicker(
                        imageUrl: _imageUrl,
                        onUpload: (imageUrl) async {
                          setState(() {
                            _imageUrl = imageUrl;
                          });
                        }),
                    SizedBox(
                      height: 30,
                    ),
                    WhiteTextField(
                        labelText: "Enter Trip Name", controller: trip_name),
                    SizedBox(
                      height: 30,
                    ),
                    OpenStreetMapWhiteSearchBar(
                        hintText: "Enter Location", controller: location),
                    //WhiteSearchBar(hintText: "Select Location", controller: location),
                    SizedBox(
                      height: 30,
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
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Color(0xFFD8DDE3),
                          width: 1.2,
                        ),
                      ),
                      child: DropdownButton<String>(
                        value: selectedValue == "Enter Custom Range"
                            ? null
                            : selectedValue,
                        hint: Text(customRange ?? "Select Budget Range"),
                        isExpanded: true,
                        underline: SizedBox(),
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 16,
                          fontFamily: "Sofia_Sans",
                          fontWeight: FontWeight.w400,
                        ),
                        icon: Icon(Icons.keyboard_arrow_down,
                            color: Color(0xFF666666)),
                        dropdownColor: Colors.grey[200],
                        onChanged: (newValue) {
                          if (newValue == "Enter Custom Range") {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                final minController = TextEditingController();
                                final maxController = TextEditingController();

                                return AlertDialog(
                                  title: Text("Enter Custom Budget Range"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: minController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            labelText: "Min Budget"),
                                      ),
                                      TextField(
                                        controller: maxController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            labelText: "Max Budget"),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        final min = minController.text;
                                        final max = maxController.text;

                                        if (min.isNotEmpty && max.isNotEmpty) {
                                          setState(() {
                                            customRange = "₹$min - ₹$max";
                                            selectedValue =
                                                "Enter Custom Range"; // Not in the list, so Dropdown won't try to match
                                          });
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: Text("Apply"),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            setState(() {
                              selectedValue = newValue;
                              customRange =
                                  null; // clear custom text if predefined selected
                            });
                          }
                        },
                        items: budgetRange.map((type) {
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
                              trip_name.text.isNotEmpty &&
                              selectedValue != null) {
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
                              trip_budget: _getSelectedBudget(),
                              cover_photo_url: _imageUrl,
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
                    SizedBox(
                      height: 50.0,
                    ),
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
