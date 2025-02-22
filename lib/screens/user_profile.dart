import 'package:flutter/material.dart';
import 'package:my_tour_planner/utilities/app_bar/bottom_app_bar.dart';


class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text("User Profile page!"),
      ],),
      bottomNavigationBar: mtp_BottomAppBar(),
    );
  }
}
