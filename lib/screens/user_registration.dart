/*
* This file will contain user login functionalities.
* Incomplete..
* */

import 'package:flutter/material.dart';
import 'package:my_tour_planner/utilities/auth/auth_gate.dart';
import 'package:my_tour_planner/utilities/auth/auth_services.dart';
import 'package:my_tour_planner/utilities/button/arrow_back_button.dart';
import 'package:my_tour_planner/utilities/button/button.dart';
import 'package:my_tour_planner/utilities/text_field/light_grey_text_field.dart';
import 'package:my_tour_planner/utilities/text/text_styles.dart';

import '../utilities/internet_connection/internet_connectivity.dart';

class UserRegistration extends StatefulWidget {
  UserRegistration({super.key});

  @override
  State<UserRegistration> createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  final authService = AuthService();

  final  email_controller = TextEditingController();

  final  name_controller = TextEditingController();

  final  password_controller = TextEditingController();

  bool isChecked = false;

  void signUp() async {
    bool hasInternet = await getInternetStatus();

    final email = email_controller.text;
    final password = password_controller.text;
    final name = name_controller.text;

    try{
      await authService.signUpWithEmailPassword(email, password, name);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthGate()));
    } catch (e){
      if(mounted){
        if (!hasInternet) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Internet Connection not Found."),
            duration: Duration(seconds: 1),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Error: Invalid Credentials : + $e"),
            duration: Duration(seconds: 1),
          ));
        } }
    }
  }

  void google_login() async {
    final res = await authService.nativeGoogleSignIn();
    if(res != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AuthGate()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ArrowBackButton(),
            InternetConnectivity(),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/MTP_Logo.png',
                width: 194,
                height: 180,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                child: Text(
                  "Create your account",
                  style: sub_heading,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: LightGreyTextField(hintText: "Email", controller: email_controller),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: LightGreyTextField(hintText: "Name", controller: name_controller),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: LightGreyTextField(hintText: "Password", controller: password_controller, obscureText: true,),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: isChecked,
                    side: const BorderSide(
                        color: Color.fromRGBO(211, 211, 211, 1), width: 1),
                    checkColor: const Color(0xFF0097B2),
                    onChanged: (value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                  Text(
                    "I accept the terms and conditions",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(53, 50, 66, 1),
                      fontSize: 15,
                      fontFamily: 'Sofia Sans',
                      fontWeight: FontWeight.w400,
                      height: 1.52,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Column(
                  children: [
                    active_button_blue(
                      onPress: () async {
                        if(email_controller.text.isEmpty || name_controller.text.isEmpty || password_controller.text.isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Please fill all the fields."), duration: Duration(milliseconds: 400),)
                          );
                        }
                        else if(isChecked == false){
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Please accept terms and conditions."), duration: Duration(milliseconds: 400),)
                          );
                        }else {
                          signUp();
                        }
                      },
                      buttonLabel: const Text(
                        "Create Account",
                        style: active_button_text_blue,
                      ),
                    ),
                    active_button_white(
                      onPress: () async {
                        bool hasInternet = await getInternetStatus();
                        if (!hasInternet) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Internet Connection not Found."),
                            duration: Duration(seconds: 1),
                          ));
                        }else{
                          google_login();
                        }
                      },
                      buttonLabel: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/goolge-icon.png",
                            width: 30,
                            height: 30,
                          ),
                          Text(
                            "Continue with Google",
                            style: active_button_text_white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
