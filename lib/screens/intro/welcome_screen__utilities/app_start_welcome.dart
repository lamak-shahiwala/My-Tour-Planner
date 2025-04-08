import 'package:flutter/material.dart';
import 'package:my_tour_planner/services/auth_gate.dart';
import 'package:my_tour_planner/utilities/text/text_styles.dart';
import 'dart:async';

class AppStartWelcome extends StatefulWidget {
  const AppStartWelcome({super.key});

  @override
  State<AppStartWelcome> createState() => _AppStartWelcomeState();
}

class _AppStartWelcomeState extends State<AppStartWelcome> {

  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 1400), () {
      // Navigate to HomeScreen after 1 seconds
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthGate()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/MTP_Logo.png',
            width: 320,
            height: 300,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FittedBox(
                child: Text(
                  "MY",
                  style: LogoNameStyle1,
                ),
              ),
              FittedBox(
                child: Text(
                  "TOUR",
                  style: LogoNameStyle2,
                ),
              ),
            ],
          ),
          FittedBox(
            child: Text(
              "PLANNER",
              style: LogoNameStyle1,
            ),
          ),
        ],
      ),
    );
  }
}


