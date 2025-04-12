import 'package:flutter/material.dart';
import 'package:my_tour_planner/screens/preferences/budget_preference.dart';
import 'package:my_tour_planner/utilities/button/arrow_back_button.dart';
import 'package:my_tour_planner/utilities/checkbox/blue_inside_text_checkbox.dart';
import 'package:my_tour_planner/utilities/text/text_styles.dart';
import '../../utilities/button/button.dart';
import '../home/home.dart';

class MonthPreference extends StatefulWidget {
  MonthPreference({super.key});

  @override
  State<MonthPreference> createState() => _MonthPreferenceState();
}

class _MonthPreferenceState extends State<MonthPreference> {
  Map<String, bool> selectionsMap = {
    'January': false,
    'Febuary': false,
    'March': false,
    'April': false,
    'May': false,
    'June': false,
    'July': false,
    'August': false,
    'September': false,
    'October': false,
    'November': false,
    'December': false,
  };

  List<String> getSelectedCategories() {
    return selectionsMap.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }

  bool hasAtLeastOneSelected() {
    return getSelectedCategories().length >= 1;
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
                      "What months do you find ideal \nfor traveling?",
                      style: sub_heading,
                      textAlign: TextAlign.center,
                    )),
                Center(
                    child: Text(
                      "Select all that apply",
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
                      height: 0,
                      width: 130,
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
                        if (hasAtLeastOneSelected()) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Home()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Please select at least one month"), duration: Duration(milliseconds: 400),));
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
