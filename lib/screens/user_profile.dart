import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_tour_planner/utilities/app_bar/bottom_app_bar.dart';
import 'package:my_tour_planner/utilities/button/button.dart';
import 'package:my_tour_planner/utilities/text/text_styles.dart';


class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> with SingleTickerProviderStateMixin {
  final String image = "";

  final String Name = "Lamak Shahiwala";

  final String UserName = "traveller@2004";

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});  // Rebuild UI when tab index changes
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              ),
            ),
          ],
        ),
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Color.fromRGBO(0, 151, 178, 1)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(title: Text(Name, style: TextStyle(color: Colors.white, fontSize: 24))),
                    active_button_white(onPress: (){}, buttonLabel: Text("Edit Profile"), circularBorderRadius: 50, width: 120,)
                  ],
                ),
              ),
              ListTile(leading: Icon(Icons.toggle_on_outlined), title: Text('Theme'), onTap: () {}),
              ListTile(leading: Icon(Icons.settings), title: Text('Settings'), onTap: () {}),
              ListTile(leading: Icon(Icons.logout), title: Text('Logout'), onTap: () {}),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Profile Picture
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                      image,
                    ),
                  ),

                  SizedBox(height: 10,),
                  Text(Name, style: sub_heading,),
                  SizedBox(height: 5,),
                  Text(UserName, style: sub_sub_heading),
                ],
              ),
            ),

            SizedBox(height: 10),

            TabBar(
              controller: _tabController,
              tabs: [
                Tab(icon: SvgPicture.asset( _tabController.index == 0 ? "assets/images/icons/my-trips-active-icon.svg" : "assets/images/icons/my-trips-notactive-icon.svg"),),
                Tab(icon: Icon(Icons.bookmark_outline_rounded, color: _tabController.index == 1 ? Color.fromRGBO(0, 151, 178, 1) : Color.fromRGBO(211, 211, 211, 1),size: 24), ),
              ],
            ),

            // Tab Bar Views (Post Grid & Reels Grid)
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [

                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: mtp_BottomAppBar(selectedIndex: 2),
      ),
    );
  }
}
