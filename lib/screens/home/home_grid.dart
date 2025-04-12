import 'package:flutter/material.dart';
import 'package:my_tour_planner/screens/home/trip_template_view.dart';

class HomeGrid extends StatelessWidget {
  final List<Map<String, String>> tripDetails = [
    {
      'title': 'Trip Template 1',
      'image': '',
      'location': 'New York',
    },
    {
      'title': 'Trip Template 2',
      'image': '',
      'location': 'Los Angeles',
    },
    {
      'title': 'Trip Template 3',
      'image': '',
      'location': 'Paris',
    },
    {
      'title': 'Trip Template 4',
      'image': '',
      'location': 'Tokyo',
    },
    {
      'title': 'Trip Template 5',
      'image': '',
      'location': 'London',
    },
    {
      'title': 'Trip Template 6',
      'image': '',
      'location': 'London',
    },
    {
      'title': 'Trip Template 7',
      'image': '',
      'location': 'London',
    },
    {
      'title': 'Trip Template 8',
      'image': '',
      'location': 'London',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Discover your next \ndestination",
              style: TextStyle(
                color: Color(0xFF353242),
                fontSize: 25,
                fontFamily: 'Sofia Sans',
                fontWeight: FontWeight.w800,
                height: 1.3,
              ),
            ),
          ),
          HomeGridSection(Categorytitle: 'Trending Now', tripDetails: tripDetails),
          HomeGridSection(Categorytitle: 'Recommended For You', tripDetails: tripDetails),
          HomeGridSection(Categorytitle: 'Adventurous', tripDetails: tripDetails),
          HomeGridSection(Categorytitle: 'Popular', tripDetails: tripDetails),
          HomeGridSection(Categorytitle: 'Relaxation', tripDetails: tripDetails),
          HomeGridSection(Categorytitle: 'Family Friendly', tripDetails: tripDetails),
        ],
      ),
    );
  }
}

class HomeGridSection extends StatelessWidget {
  final String Categorytitle;
  final List<Map<String, String>> tripDetails;

  HomeGridSection({required this.Categorytitle, required this.tripDetails});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            Categorytitle,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 370,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 1.35,
              mainAxisSpacing: 10,
            ),
            itemCount: tripDetails.length,
            itemBuilder: (context, index) {
              final trip_template = tripDetails[index];

              // Padding for first and last items
              double leftPadding = index == 0 ? 20.0 : 0.0;
              double rightPadding = index == tripDetails.length - 1 ? 20.0 : 0.0;

              return Padding(
                padding: EdgeInsets.only(left: leftPadding, right: rightPadding),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TripTemplateView(
                          title: trip_template['title']!,
                          location: trip_template['location']!,
                          image: trip_template['image']!,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            trip_template['image']!,
                            height: 370,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trip_template['title']!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                trip_template['location']!,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
