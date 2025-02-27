/*
* This file will contain user registration functionalities.
* *IMP*
* */
import 'package:flutter/material.dart';
import 'package:my_tour_planner/screens/home.dart';
import 'package:my_tour_planner/utilities/button/arrow_back_button.dart';
import 'package:my_tour_planner/utilities/button/button.dart';
import 'package:my_tour_planner/utilities/text/text_styles.dart';
import 'package:my_tour_planner/utilities/text_field/light_grey_text_field.dart';

import '../utilities/auth/login_auth.dart';

class UserLogin extends StatelessWidget {
  UserLogin({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final String sub_heading1 = "Login";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              ArrowBackButton(),
              Image.asset(
                'assets/images/MTP_Logo.png',
                width: 194,
                height: 144,
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                sub_heading1,
                style: sub_heading,
              ),
              const SizedBox(
                height: 30,
              ),
              LightGreyTextField(hintText: "Email", controller: email),
              const SizedBox(
                height: 20,
              ),
              LightGreyTextField(hintText: "Password", controller: password),
              const SizedBox(
                height: 30,
              ),
              active_button_blue(
                onPress: () async {
                  var authValue = await login_auth(
                    context,
                    email.text.trim(),
                    password.text.trim(),
                  );
                  if (authValue == 'true') {
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Home()));
                  }
                },
                buttonLabel: const Text(
                  "Login",
                  style: active_button_text_blue,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              active_button_white(
                onPress: () {},
                buttonLabel: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/goolge-icon.png",
                      width: 30,
                      height: 30,
                    ),
                    const Text(
                      "Continue with Google",
                      style: active_button_text_white,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 250,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
