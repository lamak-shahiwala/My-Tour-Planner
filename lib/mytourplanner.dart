import 'package:flutter/material.dart';
import 'package:my_tour_planner/theme/perl.dart';
import 'package:my_tour_planner/screens/intro/welcome.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: "https://lyasmbjryerqzhttncmr.supabase.co",
      anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx5YXNtYmpyeWVycXpodHRuY21yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA5NDM5MDEsImV4cCI6MjA1NjUxOTkwMX0.TjqeZ-75-5PE0xOsDq8ovuXvFFx2QQyWpld7WaYEe2Q",
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