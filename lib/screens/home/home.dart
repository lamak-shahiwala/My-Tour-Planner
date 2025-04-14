import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_tour_planner/services/fetch_profile_photo.dart';
import 'package:my_tour_planner/utilities/app_bar/bottom_app_bar.dart';
import 'package:my_tour_planner/utilities/search_bar/grey_search_bar.dart';
import 'home_grid.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController trip_template = TextEditingController();
  String searchQuery = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    trip_template.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () {
        setState(() {
          searchQuery = trip_template.text.trim();
        });
      });
    });
  }

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
            FetchProfilePhoto(avatarRadius: 24),
            const SizedBox(width: 7),
            Expanded(
              child: GreySearchBar(
                hintText: "Search Trip Templates",
                controller: trip_template,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.filter_alt_rounded,
                color: Color.fromRGBO(211, 211, 211, 1),
                size: 32,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(child: HomeGrid(searchQuery: searchQuery)),
        ],
      ),
      bottomNavigationBar: mtp_BottomAppBar(
        selectedIndex: 0,
      ),
    );
  }
}
