import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_tour_planner/screens/welcome.dart';
import 'package:my_tour_planner/utilities/text/text_styles.dart';

class AppStartWelcome extends StatefulWidget {
  const AppStartWelcome({super.key});

  @override
  State<AppStartWelcome> createState() => _AppStartWelcomeState();
}

class _AppStartWelcomeState extends State<AppStartWelcome> {

  @override
  void initState() {
    super.initState();

    // Set a delay for the welcome screen (e.g., 3 seconds)
    Timer(const Duration(seconds: 1), () {
      // Navigate to HomeScreen after 3 seconds
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const expand_welcome()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/MTP_Logo.png',
          width: 320,
          height: 239,
        ),
        const SizedBox(
          height: 25,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "MY",
              style: LogoNameStyle1,
            ),
            SizedBox(
              width: 18,
            ),
            Text(
              "TOUR",
              style: LogoNameStyle2,
            ),
          ],
        ),
        const Text(
          "PLANNER",
          style: LogoNameStyle1,
        ),
        const SizedBox(
          height: 30,
        )
      ],
    );
  }
}


