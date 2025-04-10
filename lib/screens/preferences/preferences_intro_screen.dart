import 'package:flutter/material.dart';
import 'package:my_tour_planner/screens/home/home.dart';
import 'package:my_tour_planner/screens/preferences/trip_type_preference.dart';
import 'package:my_tour_planner/utilities/button/button.dart';

import '../../utilities/button/arrow_back_button.dart';
import '../../utilities/text/text_styles.dart';

class PreferencesIntroScreen extends StatelessWidget {
  const PreferencesIntroScreen({super.key});

  final String para1 =
      "Next, we will adjust some details to \ncomplete your profile and give you a \nunique experience.";
  final String sub_heading1 = "One more step.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Align(alignment: Alignment.topLeft, child: ArrowBackButton()),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: SizedBox(
                height: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/preferences_intro.png',
                      width: 300,
                      height: 300,
                    ),
                    Text(
                      sub_heading1,
                      style: sub_heading,
                    ),
                    Text(
                      para1,
                      textAlign: TextAlign.justify,
                      style: lightGrey_paragraph_text,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Expanded(
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
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => TripTypePreference()));
                        },
                        buttonLabel: Text(
                          "Continue",
                          style: active_button_text_blue,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
