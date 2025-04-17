import 'package:flutter/material.dart';
import 'package:my_tour_planner/screens/auth/forgot_password.dart';
import 'package:my_tour_planner/screens/auth/user_registration.dart';
import 'package:my_tour_planner/services/auth_gate.dart';
import 'package:my_tour_planner/services/auth_services.dart';
import 'package:my_tour_planner/utilities/button/arrow_back_button.dart';
import 'package:my_tour_planner/utilities/button/button.dart';
import 'package:my_tour_planner/services/internet_connectivity.dart';
import 'package:my_tour_planner/utilities/text_field/light_grey_text_field.dart';
import 'package:my_tour_planner/utilities/text/text_styles.dart';

class UserLogin extends StatefulWidget {
  UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final authService = AuthService();

  final email_controller = TextEditingController();
  final password_controller = TextEditingController();

  bool _obscurePassword = true;

  void login() async {
    final email = email_controller.text;
    final password = password_controller.text;
    bool hasInternet = await getInternetStatus();
    try {
      await authService.logInWithEmailPassword(email, password);
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            children: [
              Image.asset(
                'assets/images/MTP_Logo.png',
                width: 194,
                height: 180,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: Color.fromRGBO(53, 50, 66, 1),
                    fontSize: 22,
                    fontFamily: 'Sofia_Sans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: LightGreyTextField(
                    hintText: "Email", controller: email_controller),
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => ForgotPassword()));
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    "Forgot password?",
                    style: TextStyle(
                      color: Color.fromRGBO(0, 151, 178, 1),
                      fontSize: 14,
                      fontFamily: 'Sofia_Sans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: active_button_blue(
                  onPress: () async {
                    bool hasInternet = await getInternetStatus();
                    if (!hasInternet) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Internet Connection not Found."),
                        duration: Duration(seconds: 1),
                      ));
                    }
                    if (email_controller.text.isEmpty ||
                        password_controller.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please fill all the fields."),
                        duration: Duration(milliseconds: 400),
                      ));
                    } else {
                      login();
                    }
                  },
                  buttonLabel: const Text(
                    "Login",
                    style: active_button_text_blue,
                  ),
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
                      "Don't have an account? ",
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
                              builder: (context) => UserRegistration())),
                      child: Text(
                        "Register Now",
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
      ),
    );
  }
}
