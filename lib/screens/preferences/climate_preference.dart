import 'package:flutter/material.dart';
import 'package:my_tour_planner/screens/preferences/month_preference.dart';

import '../../utilities/button/arrow_back_button.dart';
import '../../utilities/button/button.dart';
import '../../utilities/text/text_styles.dart';
import '../home/home.dart';

class ClimatePreference extends StatefulWidget {
  const ClimatePreference({super.key});

  @override
  State<ClimatePreference> createState() => _ClimatePreferenceState();
}

class _ClimatePreferenceState extends State<ClimatePreference> {
  Map<String, bool> selectionsMap = {
    'Hot and Sunny': false,
    'Snowy': false,
    'Cool and Dry': false,
    'Rainy': false,
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
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(children: [
              Center(
                child: Text(
                  "What type of climate do you \nenjoy most while travelling?",
                  style: sub_heading,
                  textAlign: TextAlign.center,
                ),
              ),
              Center(
                child: Text(
                  "Select one or more",
                  style: lightGrey_paragraph_text,
                ),
              )
            ]),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                ),
                child: Wrap(
                  direction: Axis.vertical,
                  children: selectionsMap.keys.map((label) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        children: [
                          CheckboxTheme(
                            data: CheckboxThemeData(
                              side: WidgetStateBorderSide.resolveWith((states) {
                                if (states.contains(WidgetState.selected)) {
                                  return BorderSide(color: Color.fromRGBO(0, 157, 192, 1), width: 2); // border when checked
                                }
                                return BorderSide(color: Color.fromRGBO(211, 211, 211, 1), width: 2); // border when unchecked
                              }),
                              fillColor: WidgetStateProperty.resolveWith<Color>(
                                  (states) {
                                if (states.contains(WidgetState.selected)) {
                                  return const Color.fromRGBO(
                                      0, 157, 192, 1); // Active
                                }
                                return const Color.fromRGBO(
                                    254, 254, 254, 1); // Inactive
                              }),
                            ),
                            child: Checkbox(
                              value: selectionsMap[label]!,
                              onChanged: (newValue) {
                                setState(() {
                                  selectionsMap[label] = newValue!;
                                });
                              },
                              checkColor: Color.fromRGBO(254, 254, 254, 1),
                            ),
                          ),
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: selectionsMap[label]!
                                  ? Color.fromRGBO(0, 157, 192, 1)
                                  : Color.fromRGBO(211, 211, 211, 1),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Column(
              children: [
                active_button_white(
                  onPress: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                  },
                  buttonLabel: Text(
                    "Skip Settings",
                    style: active_button_text_white,
                  ),
                ),
                active_button_blue(
                  onPress: () {
                    if (hasAtLeastOneSelected()) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MonthPreference()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please select atleast one option."),
                        duration: Duration(milliseconds: 400),
                      ));
                    }
                  },
                  buttonLabel: Text(
                    "Continue",
                    style: active_button_text_blue,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
