/*
* This file will contain user login functionalities.
* Incomplete..
* */

import 'package:flutter/material.dart';
import 'package:my_tour_planner/screens/auth/pp_and_t&c/privacy_policy_page.dart';
import 'package:my_tour_planner/screens/auth/pp_and_t&c/terms_and_conditions_page.dart';
import 'package:my_tour_planner/screens/auth/user_login.dart';
import 'package:my_tour_planner/services/auth_gate.dart';
import 'package:my_tour_planner/services/auth_services.dart';
import 'package:my_tour_planner/utilities/button/arrow_back_button.dart';
import 'package:my_tour_planner/utilities/button/button.dart';
import 'package:my_tour_planner/utilities/text_field/light_grey_text_field.dart';
import 'package:my_tour_planner/utilities/text/text_styles.dart';

import '../../services/internet_connectivity.dart';

class UserRegistration extends StatefulWidget {
  UserRegistration({super.key});

  @override
  State<UserRegistration> createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  final authService = AuthService();

  final email_controller = TextEditingController();

  final name_controller = TextEditingController();

  final password_controller = TextEditingController();

  bool _obscurePassword = true;
  bool isChecked = false;

  final List<String> allowedEmailDomains = [
    // Popular Providers
    'gmail.com',
    'outlook.com',
    'hotmail.com',
    'live.com',
    'yahoo.com',
    'icloud.com',
    'me.com',
    'aol.com',

    // Privacy-Focused
    'protonmail.com',
    'tutanota.com',
    'mailfence.com',
    'posteo.de',

    // Other Free Providers
    'zoho.com',
    'gmx.com',
    'gmx.net',
    'mail.com',
    'yandex.com',
    'yandex.ru',
  ];

  bool isValidEmailDomain(String email) {
    final domain = email.split('@').last.toLowerCase();
    return allowedEmailDomains.contains(domain);
  }

  void signUp() async {
    bool hasInternet = await getInternetStatus();

    final email = email_controller.text;
    final password = password_controller.text;
    final name = name_controller.text;

    if (isValidEmailDomain(email)) {
      try {
        await authService.signUpWithEmailPassword(email, password, name);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AuthGate()));
      } catch (e) {
        if (mounted) {
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
          }
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Invalid Email"),
        duration: Duration(seconds: 1),
      ));
    }
  }

  void google_login() async {
    final res = await authService.nativeGoogleSignIn();
    if (res != null) {
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
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 0),
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
                child: LightGreyTextField(
                    hintText: "Email", controller: email_controller),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: LightGreyTextField(
                    hintText: "Name", controller: name_controller),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: TextField(
                  controller: password_controller,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: textField_placeholder,
                    filled: true,
                    fillColor: const Color(0xFFF4F4F4),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        color: Color(0xFFC4C4C4),
                        width: .2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        color: Color(0xFFF4F4F4),
                        width: .2,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: const Color.fromRGBO(117, 117, 117, 1),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Small Checkbox
                  Checkbox(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4), // make it tighter/smaller
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeColor: const Color.fromRGBO(0, 157, 192, 1),
                    side: const BorderSide(
                      color: Color.fromRGBO(211, 211, 211, 1),
                      width: 1,
                    ),
                    checkColor: const Color.fromRGBO(254, 254, 254, 1),
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                  const SizedBox(width: 8),

                  // Text part
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // First line
                        Wrap(
                          children: [
                            const Text(
                              "I accept the ",
                              style: TextStyle(
                                color: Color.fromRGBO(53, 50, 66, 1),
                                fontSize: 14,
                                fontFamily: 'Sofia_Sans',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => TermsAndConditionsPage()),
                              ),
                              child: const Text(
                                "Terms & Conditions",
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 151, 178, 1),
                                  fontSize: 14,
                                  fontFamily: 'Sofia_Sans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "& ",
                              style: TextStyle(
                                color: Color.fromRGBO(53, 50, 66, 1),
                                fontSize: 14,
                                fontFamily: 'Sofia_Sans',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
                              ),
                              child: const Text(
                                "Privacy Policy",
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 151, 178, 1),
                                  fontSize: 14,
                                  fontFamily: 'Sofia_Sans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
                        bool hasInternet = await getInternetStatus();
                        if (!hasInternet) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Internet Connection not Found."),
                            duration: Duration(seconds: 1),
                          ));
                        }
                        if (email_controller.text.isEmpty ||
                            name_controller.text.isEmpty ||
                            password_controller.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Please fill all the fields."),
                            duration: Duration(milliseconds: 400),
                          ));
                        } else if (isChecked == false) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text("Please accept terms and conditions."),
                            duration: Duration(milliseconds: 400),
                          ));
                        } else {
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
                        } else {
                          google_login();
                        }
                      },
                      buttonLabel: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/google-icon.png",
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                              color: Color.fromRGBO(53, 50, 66, 1),
                              fontSize: 14,
                              fontFamily: 'Sofia_Sans',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserLogin())),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Color.fromRGBO(0, 151, 178, 1),
                                fontSize: 14,
                                fontFamily: 'Sofia_Sans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
