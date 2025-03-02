/*
* This file will contain user registration functionalities.
* *IMP*
* */
import 'package:flutter/material.dart';
import 'package:my_tour_planner/screens/user_registration.dart';
import 'package:my_tour_planner/utilities/auth/auth_gate.dart';
import 'package:my_tour_planner/utilities/auth/auth_services.dart';
import 'package:my_tour_planner/utilities/button/arrow_back_button.dart';
import 'package:my_tour_planner/utilities/button/button.dart';
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

  void login() async {
    final email = email_controller.text;
    final password = password_controller.text;

    try{
      await authService.logInWithEmailPassword(email, password);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthGate()));
    }catch(e){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: Invalid Credentials : + $e"),duration: Duration(seconds: 1),));
      }
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
        title: ArrowBackButton(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
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
                  style: sub_heading,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: LightGreyTextField(hintText: "Email", controller: email_controller),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: LightGreyTextField(hintText: "Password", controller: password_controller, obscureText: true,),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text( "Don't have an account? ",style: TextStyle(
                      color: Color.fromRGBO(53, 50, 66, 1),
                      fontSize: 14,
                      fontFamily: 'Sofia_Sans',
                      fontWeight: FontWeight.w300,
                    ),),
                    GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => UserRegistration())),
                      child: Text( "Register Now",style: TextStyle(
                        color: Colors.indigoAccent,
                        fontSize: 14,
                        fontFamily: 'Sofia_Sans',
                        fontWeight: FontWeight.w600,
                      ),),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: active_button_blue(
                  onPress: (){
                    if(email_controller.text.isEmpty || password_controller.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please fill all the fields."),
                            duration: Duration(milliseconds: 400),)
                      );
                    }else{
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
                onPress: () {
                    google_login();
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
      ),
    );
  }
}
