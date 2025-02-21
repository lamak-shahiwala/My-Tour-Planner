/*
* This file will contain user registration functionalities.
* *IMP*
* */
import 'package:flutter/material.dart';
import 'package:my_tour_planner/utilities/app_bar/bottom_app_bar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Yo!"),
            Text("Home Screen"),
          ],),
      ),
      bottomNavigationBar: mtp_BottomAppBar(),
    );
  }
}