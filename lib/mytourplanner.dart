import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:my_tour_planner/services/consts.dart';
import 'package:my_tour_planner/theme/perl.dart';
import 'package:my_tour_planner/screens/intro/welcome.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SUPABASE_PROJECT_URL,
    anonKey: SUPABASE_API_KEY,
  );
  Gemini.init(apiKey: GEMINI_API_KEY);
  runApp(MaterialApp(
    home: const welcome(),
    theme: pearl,
    debugShowCheckedModeBanner: false,
  ));
}

class MyTourPlanner extends StatelessWidget {
  const MyTourPlanner({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Column(
      children: [
        Text(
            "IS THIS EVEN WINDOW ACTIVE?? NO RIGHT??? LOL I JUST WANTED TO HAVE A WIDGET WITH APP'S NAME ")
      ],
    ));
  }
}
