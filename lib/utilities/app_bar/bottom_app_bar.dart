import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_tour_planner/screens/create_or_generate__trip.dart';
import 'package:my_tour_planner/screens/home.dart';
import 'package:my_tour_planner/screens/user_profile.dart';


class mtp_BottomAppBar extends StatefulWidget {
  mtp_BottomAppBar({super.key, required this.selectedIndex,});
  int selectedIndex;
  @override
  State<mtp_BottomAppBar> createState() => _mtp_BottomAppBarState();
}

class _mtp_BottomAppBarState extends State<mtp_BottomAppBar> {

  String home_active = "assets/images/icons/home-active-icon.svg";
  String home_not_active = "assets/images/icons/home-notactive-icon.svg";
  String create_generate_active = "assets/images/icons/create_generate-active-icon.svg";
  String create_generate_not_active = "assets/images/icons/create_generate-notactive-icon.svg";

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
      if(index == 0){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
      }
      if(index == 1){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Create_or_Generate__Trip()));

      }
      if(index == 2){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserProfile()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 4,
      color: Color.fromRGBO(252, 252, 252, 1),

      child: Container(
        height: 72,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(onPressed: () => _onItemTapped(0),
              icon: SvgPicture.asset( widget.selectedIndex == 0 ?
                home_active : home_not_active, height: 24,
                width: 24,),),
            IconButton(onPressed: () => _onItemTapped(1),
              icon: SvgPicture.asset( widget.selectedIndex == 1 ?
               create_generate_active : create_generate_not_active, height: 24,
                width: 24,),),
            IconButton(onPressed: () => _onItemTapped(2),
                icon: Icon(
                  Icons.person, color: widget.selectedIndex == 2 ? Color.fromRGBO(0, 151, 178, 1) : Color.fromRGBO(211, 211, 211, 1),
                  size: 26,)),
          ],
        ),
      ),
    );
  }
}