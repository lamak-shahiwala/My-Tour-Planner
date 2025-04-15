import 'package:flutter/material.dart';
import 'package:my_tour_planner/screens/profile/my_trip_screens/my_trip_template.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> userTrips = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTrips();
  }

  Future<void> _fetchTrips() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    final response = await _supabase
        .from('Trip')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    setState(() {
      userTrips = List<Map<String, dynamic>>.from(response);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userTrips.isEmpty) {
      return const Center(child: Text("No Trips Created yet."));
    }

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 3 / 4, // Consistent look
            ),
            itemCount: userTrips.length,
            itemBuilder: (context, index) {
              final trip = userTrips[index];
              return GestureDetector(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MyTripTemplateView(
                        title: trip['trip_name'] ?? 'No Title',
                        image: trip['cover_photo_url'] ?? '',
                        location: trip['city_location'] ?? 'Unknown',
                        tripID: trip['trip_id'],
                        // templateID: templateId,
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      trip['cover_photo_url'] != null &&
                              trip['cover_photo_url'] != ''
                          ? Image.network(
                              trip['cover_photo_url'],
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: Colors.grey[300],
                              alignment: Alignment.center,
                              child: const Text("No Image"),
                            ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.6)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        left: 12,
                        right: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trip['trip_name'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              trip['city_location'] ?? '',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
