import 'package:flutter/material.dart';
import 'package:my_tour_planner/utilities/theme/perl.dart';
import 'package:my_tour_planner/screens/welcome.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: "https://ksxgzidwvxknouozwoaf.supabase.co",
      anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtzeGd6aWR3dnhrbm91b3p3b2FmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA4NTcwMDcsImV4cCI6MjA1NjQzMzAwN30.u9zp5x-OrKA_ADF2ENyHjzYlM-MKsYvwZo0TMc10H4c",
  );
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