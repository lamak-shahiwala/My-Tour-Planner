import 'package:flutter/material.dart';
import 'package:my_tour_planner/screens/intro/welcome_screen__utilities/welcome_page_view.dart';
import 'package:my_tour_planner/screens/intro/welcome_screen__utilities/welcome_auth_buttons.dart';
import 'package:my_tour_planner/screens/intro/welcome_screen__utilities/app_start_welcome.dart';

class welcome extends StatelessWidget {
  const welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: AppStartWelcome(),
      ),
    );
  }
}

class expand_welcome extends StatelessWidget {
  const expand_welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 500,
              child: page_view_for_features(),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: WelcomeAuthButtons(),
            ),
          ],
        ),
      ),
    );
  }
}
