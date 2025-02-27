import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_tour_planner/screens/create_or_generate__trip.dart';
import 'package:my_tour_planner/screens/home.dart';
import 'package:my_tour_planner/screens/user_profile.dart';

class mtp_BottomAppBar extends StatefulWidget {
  const mtp_BottomAppBar({super.key});

  @override
  State<mtp_BottomAppBar> createState() => _mtp_BottomAppBarState();
}

class _mtp_BottomAppBarState extends State<mtp_BottomAppBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Color.fromRGBO(250, 250, 250, 1),
      child: Container(
        height: 72,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
            },
              icon: SvgPicture.asset(
                "assets/images/icons/home.svg", height: 24,
                width: 24,),),
            IconButton(onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Create_or_Generate__Trip()));
            },
              icon: SvgPicture.asset(
                "assets/images/icons/create_generate.svg", height: 24,
                width: 24,),),
            IconButton(onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const UserProfile()));
            },
                icon: Icon(
                  Icons.person, color: Color.fromRGBO(211, 211, 211, 1),
                  size: 24,)),
          ],
        ),
      ),
    );
  }
}