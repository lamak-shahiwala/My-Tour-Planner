import 'package:flutter/material.dart';
import 'package:my_tour_planner/screens/chat_bot/chat_bot.dart';
import 'package:my_tour_planner/screens/create_trip/create_trip.dart';
import 'package:my_tour_planner/screens/generate_trip/generate_trip.dart';
import 'package:my_tour_planner/services/fetch_profile_photo.dart';
import 'package:my_tour_planner/utilities/app_bar/bottom_app_bar.dart';
import 'package:my_tour_planner/utilities/text/text_styles.dart';
import 'package:my_tour_planner/utilities/button/button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../utilities/button/floating_button.dart';

class Create_or_Generate__Trip extends StatefulWidget {
  Create_or_Generate__Trip({super.key});

  @override
  State<Create_or_Generate__Trip> createState() => _Create_or_Generate__TripState();
}

class _Create_or_Generate__TripState extends State<Create_or_Generate__Trip> {
  final SupabaseClient _supabase = Supabase.instance.client;

  late String Name;

  String? getFullName() {
    final session = _supabase.auth.currentSession;
    if (session == null) return null;
    return session.user.userMetadata?['full_name'];
  }

  @override
  void initState() {
    super.initState();
    Name = getFullName() ?? "Guest";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingButton(
        buttonPadding: EdgeInsets.symmetric(horizontal: 6, vertical:  6,),
        buttonBackgroundColor: Color.fromRGBO(0, 157, 192, 0.2),
        buttonHeroTag: 'chat_button',
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatBot()));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FetchProfilePhoto(avatarRadius: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(
                      "Hello, " + Name + ".",
                      style: hello_user,
                    ),
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
      bottomNavigationBar: mtp_BottomAppBar(selectedIndex: 1),
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
