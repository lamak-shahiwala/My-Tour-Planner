import 'package:flutter/material.dart';
import 'package:my_tour_planner/screens/home/trip_template_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RecommendedSection extends StatefulWidget {
  const RecommendedSection({super.key});

  @override
  State<RecommendedSection> createState() => _RecommendedSectionState();
}

class _RecommendedSectionState extends State<RecommendedSection> {
  bool isLoading = true;
  List<Map<String, String>> recommendedTrips = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchRecommendedTrips();
  }

  Future<void> fetchRecommendedTrips() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      recommendedTrips = [];
    });

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      setState(() {
        isLoading = false;
        errorMessage = "User not logged in.";
      });
      return;
    }

    final url = Uri.parse('https://mtpbyphoenix.pythonanywhere.com/recommend');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> trips = json['Recommended Trips'];

        recommendedTrips = trips.map<Map<String, String>>((trip) {
          return {
            'title': (trip['trip_name'] ?? '').toString(),
            'image': (trip['cover_photo_url'] ?? '').toString(),
            'location': (trip['city_location'] ?? '').toString(),
            'trip_id': (trip['trip_id'] ?? '').toString(),
            'template_id': (trip['template_id'] ?? '').toString(),
          };
        }).toList();
      } else {
        setState(() {
          errorMessage =
          'Failed to fetch recommendations: ${response.statusCode} - ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching recommendations: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Center(
          child: Text(
            errorMessage!,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (recommendedTrips.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Center(
          child: Text(
            "No recommendations available for you right now.",
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Recommended for You",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 370,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 1.35,
              mainAxisSpacing: 10,
            ),
            itemCount: recommendedTrips.length,
            itemBuilder: (context, index) {
              final trip = recommendedTrips[index];
              double leftPadding = index == 0 ? 20.0 : 0.0;
              double rightPadding =
              index == recommendedTrips.length - 1 ? 20.0 : 0.0;

              return Padding(
                padding:
                EdgeInsets.only(left: leftPadding, right: rightPadding),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TripTemplateView(
                          title: trip['title']!,
                          location: trip['location']!,
                          image: trip['image']!,
                          templateID: int.parse(trip['template_id']!),
                          tripID: int.parse(trip['trip_id']!),
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
                        trip['image'] != ''
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: trip['image']!.contains("assets/images/")
                              ? Image.asset(
                            trip['image']!,
                            height: 370,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                              : Image.network(
                            trip['image']!,
                            height: 370,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) {
                              return Container(
                                color: const Color.fromRGBO(
                                    111, 111, 111, 1),
                                alignment: Alignment.center,
                                child: const Text(
                                  "[Image Error]",
                                  style: TextStyle(
                                    color: Color.fromRGBO(
                                        50, 50, 50, 1),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                            : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromRGBO(111, 111, 111, 1),
                          ),
                          height: 370,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: const Text(
                            "[No Image]",
                            style: TextStyle(
                              color: Color.fromRGBO(50, 50, 50, 1),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trip['title']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                trip['location']!,
                                style: const TextStyle(
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
