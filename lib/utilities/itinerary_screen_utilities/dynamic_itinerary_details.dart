import 'package:flutter/material.dart';
import 'package:my_tour_planner/utilities/text_field/Itinerary_detail_name__textfield.dart';
import 'package:my_tour_planner/utilities/text_field/expandable_custom_itinerary_note__textfield.dart';
import 'package:my_tour_planner/utilities/time_picker/white_time_picker.dart';

class DynamicItineraryDetails extends StatefulWidget {
  @override
  _DynamicItineraryDetailsState createState() =>
      _DynamicItineraryDetailsState();
}

class _DynamicItineraryDetailsState extends State<DynamicItineraryDetails> {
  List<TextEditingController> itinerary_detail_name_controllers = [];
  List<TextEditingController> itinerary_custom_note_controllers = [];

  @override
  void initState() {
    super.initState();
    addDynamicItineraryDetail(); // Add one text field initially
  }

  void addDynamicItineraryDetail() {
    setState(() {
      itinerary_detail_name_controllers.add(TextEditingController());
      itinerary_custom_note_controllers.add(TextEditingController());
    });
  }

  void removeDynamicItineraryDetail(int index) {
    if (itinerary_detail_name_controllers.length > 1) {
      setState(() {
        itinerary_detail_name_controllers[index].dispose();
        itinerary_detail_name_controllers.removeAt(index);
      });
    }
    if (itinerary_custom_note_controllers.length > 1) {
      setState(() {
        itinerary_custom_note_controllers[index].dispose();
        itinerary_custom_note_controllers.removeAt(index);
      });
    }
  }

  @override
  void dispose() {
    for (var controller in itinerary_detail_name_controllers) {
      controller.dispose();
    }
    for (var controller in itinerary_custom_note_controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: itinerary_detail_name_controllers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${index + 1}.",
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 16,
                              fontFamily: "Sofia_Sans",
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete,
                                color: Color.fromRGBO(178, 60, 50, 1),
                                size: 20),
                            onPressed: () =>
                                removeDynamicItineraryDetail(index),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ItineraryDetailNameTextField(
                              controller:
                                  itinerary_detail_name_controllers[index],
                              labelText: "Enter Detail Name",
                            ),
                          ),
                          SizedBox(width: 5),
                        WhiteTimePicker(),
                        ],
                      ),
                      SizedBox(height: 10),
                      ExpandableCustomItineraryNoteTextField(
                          controller: itinerary_custom_note_controllers[index]),
                    ],
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 14),
              child: GestureDetector(
                onTap: addDynamicItineraryDetail,
                child: Icon(
                    Icons.add,
                    color: const Color.fromRGBO(0, 151, 178, 1),
                    size: 24,
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
