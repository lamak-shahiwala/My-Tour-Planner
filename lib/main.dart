import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_tour_planner/screens/welcome.dart';
import 'package:my_tour_planner/utilities/theme/perl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: const welcome(), theme: pearl,));
}

class MyTourPlanner extends StatelessWidget {
  const MyTourPlanner({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      body: Column(children: [
        Text("IS THIS WINDOW ACTIVE??")
        
      ],)
    );
  }
}