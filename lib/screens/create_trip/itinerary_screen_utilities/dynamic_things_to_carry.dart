import 'package:flutter/material.dart';
import 'package:my_tour_planner/backend/classes.dart';
import 'package:my_tour_planner/backend/db_methods.dart';
import 'package:my_tour_planner/screens/create_trip/edit_itinerary.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:my_tour_planner/backend/classes.dart';

import '../../../utilities/button/save_next_button.dart';
import '../../../utilities/text/text_styles.dart';
import '../testing_edit_itinerary.dart';

class DynamicThingsToCarry extends StatefulWidget {
  @override
  _DynamicThingsToCarryState createState() => _DynamicThingsToCarryState();
}

class _DynamicThingsToCarryState extends State<DynamicThingsToCarry> {
  List<String> things_to_carry = [];
  TextEditingController things_to_carry_controller = TextEditingController();

  final things_carry_db = ThingsCarryDB();
  final tripId = Trip_ID();

  void _addItem(String item) {
    if (item.isNotEmpty) {
      setState(() {
        things_to_carry.add(item);
      });
      things_to_carry_controller
          .clear(); // Clear the input after adding the item
    }
  }

  void _removeItem(int index) {
    if (things_to_carry.length >= 1) {
      setState(() {
        things_to_carry.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const grey_paragraph_text = TextStyle(
      color: Color.fromRGBO(170, 170, 170, 1),
      fontSize: 16,
      fontFamily: 'Sofia_Sans',
      fontWeight: FontWeight.w300,
      //TextAlign.justify
    );
    const list = TextStyle(
      color: Color.fromRGBO(53, 50, 66, 1),
      fontSize: 20,
      fontFamily: 'Sofia_Sans',
      fontWeight: FontWeight.w500,
    );
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 22),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: things_to_carry_controller,
                      decoration: InputDecoration(
                        labelText: "Enter an item to carry",
                        labelStyle: grey_paragraph_text,
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (value) {
                        _addItem(value); // Add item when user presses "Enter"
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: IconButton(
                      onPressed: () {
                        _addItem(things_to_carry_controller.text);
                      },
                      icon: Icon(
                        Icons.check_circle,
                        color: const Color.fromRGBO(0, 151, 178, 1),
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: things_to_carry.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ListTile(
                    trailing: IconButton(
                      icon: Icon(Icons.delete,
                          color: Color.fromRGBO(178, 60, 50, 1), size: 20),
                      onPressed: () => _removeItem(index),
                    ),
                    title: Text(
                      "${index + 1}. " + things_to_carry[index],
                      style: list,
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: SaveNextButton(
                  onPress: () async {
                    final userId =
                        Supabase.instance.client.auth.currentUser?.id;
                    int? trip_Id = await tripId.getLatestTripId(userId!);
                    if (trip_Id != null) {
                      print("Latest Trip ID: $trip_Id");
                    }

                    final carry_item = Things_Carry(
                        trip_id: trip_Id,
                        carry_item: things_to_carry);

                    await things_carry_db.addCarryItem(carry_item);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TestingEditItineraryScreen(trip_id: trip_Id!),
                      ),
                    );
                  },
                  buttonLabel: Text(
                    "Save",
                    style: save_next_button,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
