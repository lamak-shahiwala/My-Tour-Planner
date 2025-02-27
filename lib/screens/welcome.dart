import 'package:flutter/material.dart';
import 'package:my_tour_planner/utilities/welcome_screen__utilities/app_start_welcome.dart';
import 'package:my_tour_planner/utilities/welcome_screen__utilities/welcome_auth_buttons.dart';
import 'package:my_tour_planner/utilities/welcome_screen__utilities/welcome_page_view.dart';

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
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            SizedBox(
              height: 500,
              child: page_view_for_features(),
            ),
            Spacer(),
            WelcomeAuthButtons(),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
