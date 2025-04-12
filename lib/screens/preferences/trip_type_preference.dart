import 'package:flutter/material.dart';
import 'package:my_tour_planner/screens/preferences/budget_preference.dart';
import 'package:my_tour_planner/utilities/button/arrow_back_button.dart';
import 'package:my_tour_planner/utilities/checkbox/blue_inside_text_checkbox.dart';
import 'package:my_tour_planner/utilities/text/text_styles.dart';
import '../../utilities/button/button.dart';
import '../home/home.dart';

class TripTypePreference extends StatefulWidget {
  TripTypePreference({super.key});

  @override
  State<TripTypePreference> createState() => _TripTypePreferenceState();
}

class _TripTypePreferenceState extends State<TripTypePreference> {
  Map<String, bool> selectionsMap = {
    'Adventure': false,
    'Relaxation': false,
    'Historical': false,
    'Cultural': false,
    'Beach': false,
    'Mountain': false,
    'Wildlife': false,
    'Urban Exploration': false,
    'Food': false,
    'Shopping': false,
    'Trekking': false,
    'Sightseeing': false,
  };

  List<String> getSelectedCategories() {
    return selectionsMap.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }

  bool hasAtLeastFiveSelected() {
    return getSelectedCategories().length >= 5;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: ArrowBackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Wrap(
              children: [
                Center(
                    child: Text(
                  "What things do you prefer?",
                  style: sub_heading,
                )),
                Center(
                    child: Text(
                  "Select atleast five things",
                  style: lightGrey_paragraph_text,
                )),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Wrap(
                  children: selectionsMap.keys.map((label) {
                    return BlueInsideTextCheckbox(
                      label: label,
                      value: selectionsMap[label]!,
                      onChanged: (newValue) {
                        setState(() {
                          selectionsMap[label] = newValue;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  active_button_white(
                      onPress: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      },
                      buttonLabel: Text(
                        "Skip Settings",
                        style: active_button_text_white,
                      )),
                  active_button_blue(
                      onPress: () {
                        if (hasAtLeastFiveSelected()) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BudgetPreference(
                                        selectedTripTypes: getSelectedCategories(),
                                      )));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Please select atleast five things."),
                            duration: Duration(milliseconds: 400),
                          ));
                        }
                      },
                      buttonLabel: Text(
                        "Continue",
                        style: active_button_text_blue,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
