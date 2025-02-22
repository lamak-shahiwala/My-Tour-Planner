import 'package:flutter/material.dart';
import 'package:my_tour_planner/screens/create_trip.dart';
import 'package:my_tour_planner/screens/generate_trip.dart';
import 'package:my_tour_planner/utilities/app_bar/bottom_app_bar.dart';
import 'package:my_tour_planner/utilities/text/text_styles.dart';
import 'package:my_tour_planner/utilities/button/button.dart';

class Create_or_Generate__Trip extends StatelessWidget {
  Create_or_Generate__Trip({super.key});

  final String userName = "Lamak Shahiwala";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.person)),
                  Text(
                    "Hello, " + userName + ".",
                    style: hello_user,
                  ),
                ],
              ),
              SizedBox(
                height: 150,
              ),
              Create_Generate_Buttons(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: mtp_BottomAppBar(),
    );
  }
}

class Create_Generate_Buttons extends StatelessWidget {
  const Create_Generate_Buttons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        create_generate_button(
            onPress: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTrip()));
            },
            buttonLabel: Text(
              "Create",
              style: active_button_text_blue,
            )),
        SizedBox(
          height: 30,
        ),
        create_generate_button(
            onPress: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => GenerateTrip()));
            },
            buttonLabel: Text(
              "Generate",
              style: active_button_text_blue,
            )),
      ],
    );
  }
}
