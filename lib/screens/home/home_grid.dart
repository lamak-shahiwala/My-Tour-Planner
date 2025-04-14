import 'package:flutter/material.dart';
import 'package:my_tour_planner/screens/home/trip_template_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeGrid extends StatefulWidget {
  final String searchQuery;

  const HomeGrid({super.key, this.searchQuery = ''});

  @override
  _HomeGridState createState() => _HomeGridState();
}

class _HomeGridState extends State<HomeGrid> {
  bool isLoading = true;
  Map<String, List<Map<String, String>>> categorizedTrips = {};

  @override
  void initState() {
    super.initState();
    fetchTripTemplates();
  }

  @override
  void didUpdateWidget(covariant HomeGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      fetchTripTemplates();
    }
  }

  // Mapping function for trip types
  String mapTripType(String? originalType) {
    switch (originalType) {
      case 'Historical':
      case 'Cultural':
        return 'Historical and Cultural';
      case 'Family':
      case 'Friends':
        return 'Family Friendly';
      default:
        return originalType ?? 'Other';
    }
  }

  Future<void> fetchTripTemplates() async {
    try {
      final response = await Supabase.instance.client
          .from('Template')
          .select('template_id, trip_id, Trip(trip_name, cover_photo_url, city_location, trip_type)')
          .eq('isPublic', true);

      final Map<String, List<Map<String, String>>> groupedData = {};

      for (final item in response as List) {
        final trip = item['Trip'];
        final type = mapTripType(trip['trip_type'] as String?);
        final cityLocation = (trip['city_location'] ?? '').toString();

        // 🔍 Normalize and match against user input
        if (widget.searchQuery.isNotEmpty) {
          final queryWords = widget.searchQuery.toLowerCase().split(RegExp(r'\s+'));
          final locationWords = cityLocation.toLowerCase();

          // check if any word in query matches anywhere in location
          bool matches = queryWords.any((word) => locationWords.contains(word));
          if (!matches) continue;
        }

        final tripData = {
          'title': (trip['trip_name'] ?? '').toString(),
          'image': (trip['cover_photo_url'] ?? '').toString(),
          'location': cityLocation,
          'trip_id': item['trip_id'].toString(),
          'template_id': item['template_id'].toString(),
        };

        if (!groupedData.containsKey(type)) {
          groupedData[type] = [];
        }

        groupedData[type]!.add(tripData);
      }

      setState(() {
        categorizedTrips = groupedData;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching templates: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
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
          const SizedBox(height: 10),
          ...categorizedTrips.entries.map((entry) {
            return HomeGridSection(
              Categorytitle: entry.key,
              tripDetails: entry.value,
            );
          }).toList(),
        ],
      ),
    );
  }
}

class HomeGridSection extends StatelessWidget {
  final String Categorytitle;
  final List<Map<String, String>> tripDetails;

  const HomeGridSection({
    required this.Categorytitle,
    required this.tripDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            Categorytitle,
            style: const TextStyle(
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
            itemCount: tripDetails.length,
            itemBuilder: (context, index) {
              final trip = tripDetails[index];

              double leftPadding = index == 0 ? 20.0 : 0.0;
              double rightPadding =
              index == tripDetails.length - 1 ? 20.0 : 0.0;

              return Padding(
                padding: EdgeInsets.only(left: leftPadding, right: rightPadding),
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
                          child: Image.asset(
                            trip['image']!,
                            height: 370,
                            width: double.infinity,
                            fit: BoxFit.cover,
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
