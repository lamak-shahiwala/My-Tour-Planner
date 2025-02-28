/*
* This file will contain user login functionalities.
* Incomplete..
* */

import 'package:flutter/material.dart';
import 'package:my_tour_planner/screens/home.dart';
import 'package:my_tour_planner/utilities/button/arrow_back_button.dart';
import 'package:my_tour_planner/utilities/button/button.dart';
import 'package:my_tour_planner/utilities/text_field/light_grey_text_field.dart';
import 'package:my_tour_planner/utilities/text/text_styles.dart';
import '../utilities/auth/register_auth.dart';

class UserRegistration extends StatelessWidget {
  UserRegistration({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController password = TextEditingController();
  final String sub_heading1 = "Create your account";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
              LightGreyTextField(hintText: "Name", controller: name),
              const SizedBox(
                height: 20,
              ),
              LightGreyTextField(hintText: "Password", controller: password),
              const SizedBox(
                height: 20,
              ),
              const UserLogin_checkbox(),
              const SizedBox(
                height: 140,
              ),
              active_button_blue(
                onPress: () async {
                  var authValue = await register_auth(
                    name.text.trim(),
                    email.text.trim(),
                    password.text.trim(),
                  );
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Home()));
                },
                buttonLabel: const Text(
                  "Create Account",
                  style: active_button_text_blue,
                ),
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
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserLogin_checkbox extends StatefulWidget {
  const UserLogin_checkbox({super.key});

  @override
  State<UserLogin_checkbox> createState() => _UserLogin_checkboxState();
}

class _UserLogin_checkboxState extends State<UserLogin_checkbox> {
  bool isChecked = false; // Checkbox state
  final String checkbox_text = "I accept the terms and conditions";
  final checkbox_text_style = const TextStyle(
    color: Color.fromRGBO(53, 50, 66, 1),
    fontSize: 15,
    fontFamily: 'Sofia Sans',
    fontWeight: FontWeight.w400,
    height: 1.52,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Checkbox(
          value: isChecked,
          side: const BorderSide(
              color: Color.fromRGBO(211, 211, 211, 1), width: 1),
          checkColor: const Color(0xFF0097B2),
          onChanged: (newValue) {
            setState(() {
              isChecked = newValue!;
            });
          },
        ),
        Text(
          checkbox_text,
          textAlign: TextAlign.center,
          style: checkbox_text_style,
        ),
        const Spacer(),
      ],
    );
  }
}
