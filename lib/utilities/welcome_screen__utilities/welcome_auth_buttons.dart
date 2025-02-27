import 'package:flutter/material.dart';
import 'package:my_tour_planner/screens/user_login.dart';
import 'package:my_tour_planner/screens/user_registration.dart';
import 'package:my_tour_planner/utilities/button/button.dart';
import 'package:my_tour_planner/utilities/text/text_styles.dart';

class WelcomeAuthButtons extends StatefulWidget {
  const WelcomeAuthButtons({super.key});

  @override
  State<WelcomeAuthButtons> createState() => _WelcomeAuthButtonsState();
}

class _WelcomeAuthButtonsState extends State<WelcomeAuthButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        active_button_blue(
          onPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserRegistration()), // Navigate to Login
            );
          },
          buttonLabel: const Text(
            "Create Account",
            style: active_button_text_blue,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        active_button_white(
          onPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  UserLogin()), // Navigate to Login
            );
          },
          buttonLabel: const Text(
            "Login",
            style: active_button_text_white,
          ),
        ),
      ],
    );
  }
}
