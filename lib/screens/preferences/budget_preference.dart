import 'package:flutter/material.dart';
import 'package:my_tour_planner/screens/preferences/climate_preference.dart';

import '../../utilities/button/arrow_back_button.dart';
import '../../utilities/button/button.dart';
import '../../utilities/text/text_styles.dart';
import '../home/home.dart';

class BudgetPreference extends StatefulWidget {
  final List<String> selectedTripTypes;

  const BudgetPreference({super.key, required this.selectedTripTypes});

  @override
  State<BudgetPreference> createState() => _BudgetPreferenceState();
}

class _BudgetPreferenceState extends State<BudgetPreference> {
  String selectedOption = "";

  final String budget_low = "low";
  final String budget_moderate = "moderate";
  final String budget_luxury = "luxury";

  Widget customRadio(String value, String label) {
    final isSelected = selectedOption == value;
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            RadioTheme(
              data: RadioThemeData(
                fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return const Color.fromRGBO(0, 157, 192, 1); // Active
                  }
                  return const Color.fromRGBO(211, 211, 211, 1); // Inactive
                }),
              ),
              child: Radio<String>(
                value: value,
                groupValue: selectedOption,
                onChanged: (val) => setState(() => selectedOption = val!),
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Color.fromRGBO(0, 157, 192, 1)
                    : Color.fromRGBO(211, 211, 211, 1),
              ),
            )
          ],
        ));
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
            Center(
              child: Wrap(children: [
                Text(
                  "What is your typical budget for a trip?",
                  style: sub_heading,
                  textAlign: TextAlign.center,
                ),
              ]),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    customRadio(budget_low, 'Low'),
                    customRadio(budget_moderate, 'Moderate'),
                    customRadio(budget_luxury, 'Luxury'),
                  ],
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
                  onPress: selectedOption.isNotEmpty
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ClimatePreference(
                                      selectedBudget: selectedOption,
                                      selectedTripTypes:
                                          widget.selectedTripTypes,
                                    )),
                          );
                        }
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please select a Budget option."),
                              duration: Duration(seconds: 1),
                            ),
                          );
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
