import 'package:flutter/material.dart';
import 'package:my_tour_planner/utilities/app_bar/bottom_app_bar.dart';
import 'package:my_tour_planner/utilities/search_bar/grey_search_bar.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final String image= ""; //var to store link of user profile icon
  final TextEditingController trip_template = TextEditingController(); // used for search bar
  final String home_page_title = "Discover your next \ndestination";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 85,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(
              image,
            ),
          ),
          SizedBox(width: 7,),
          Expanded(child: GreySearchBar(hintText: "Search Trip Templates", controller: trip_template)),
          IconButton(onPressed: (){}, icon: Icon(Icons.filter_alt_rounded, color: Color.fromRGBO(211, 211, 211, 1),size: 32,),),
        ],),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(home_page_title,
                style: TextStyle(
                  color: Color(0xFF353242),
                  fontSize: 25,
                  fontFamily: 'Sofia Sans',
                  fontWeight: FontWeight.w800,
                  height: 1.3,
                ),
              ),
          ],),
        ),
      ),
      bottomNavigationBar: mtp_BottomAppBar(selectedIndex: 0,),
    );
  }
}