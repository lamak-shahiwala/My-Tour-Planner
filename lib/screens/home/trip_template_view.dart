import 'package:flutter/material.dart';
import 'package:my_tour_planner/utilities/button/arrow_back_button.dart';
import 'package:my_tour_planner/utilities/button/button.dart';
import 'package:my_tour_planner/utilities/text/text_styles.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../profile/my_trip_screens/my_trip_template.dart';

class TripTemplateView extends StatefulWidget {
  const TripTemplateView({
    super.key,
    required this.title,
    required this.image,
    required this.location,
    required this.tripID,
    required this.templateID,
  });

  final tripID;
  final templateID;
  final String title;
  final String image;
  final String location;

  @override
  State<TripTemplateView> createState() => _TripTemplateViewState();
}

class _TripTemplateViewState extends State<TripTemplateView> {
  double _sheetExtent = 0.4;
  String budgetRange = "";
  String templateDescription = "";
  bool isLoading = true;
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _fetchTripDetails();
    _checkBookmarkStatus();
  }

  Future<void> _checkBookmarkStatus() async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await supabase
        .from('Bookmark')
        .select()
        .eq('user_id', userId)
        .eq('template_id', widget.templateID)
        .maybeSingle();

    setState(() {
      isBookmarked = response != null;
    });
  }

  Future<void> _toggleBookmark() async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return null;

    if (isBookmarked) {
      // Remove bookmark
      await supabase
          .from('Bookmark')
          .delete()
          .eq('user_id', userId)
          .eq('template_id', widget.templateID);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bookmark removed")),
      );
    } else {
      // Add bookmark
      await supabase.from('Bookmark').insert({
        'user_id': userId,
        'template_id': widget.templateID,
        'date_bookmarked': DateTime.now().toIso8601String(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bookmark added")),
      );
    }

    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

  Future<void> cloneTemplateTripToUser({
    required int templateId,
    required BuildContext context,
  }) async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must be logged in.")),
      );
      return;
    }

    try {
      print("▶️ Step 1: Get template's original trip ID");
      final templateResponse = await supabase
          .from('Template')
          .select('trip_id')
          .eq('template_id', templateId)
          .maybeSingle();

      final originalTripId = templateResponse?['trip_id'];
      if (originalTripId == null) throw Exception("No trip found in template.");

      print("✅ Template has original tripID: $originalTripId");

      print("▶️ Step 2: Fetch trip data");
      final originalTrip = await supabase
          .from('Trip')
          .select()
          .eq('trip_id', originalTripId)
          .maybeSingle();

      if (originalTrip == null)
        throw Exception("Original trip data not found.");

      print("▶️ Step 3: Creating new trip for user");
      final newTrip = await supabase
          .from('Trip')
          .insert({
            'trip_name': originalTrip['trip_name'],
            'city_location': originalTrip['city_location'],
            'trip_budget': originalTrip['trip_budget'],
            'cover_photo_url': originalTrip['cover_photo_url'] ?? '',
            'user_id': userId,
            'trip_type': originalTrip['trip_type'],
            'start_date': originalTrip['start_date'],
            'end_date': originalTrip['end_date'],
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      final newTripId = newTrip['trip_id'];
      print("✅ New trip created with trip_id: $newTripId");

      print("▶️ Step 4: Cloning itinerary");
      final oldItineraries = await supabase
          .from('Itinerary')
          .select()
          .eq('trip_id', originalTripId);

      for (final old in oldItineraries) {
        final newItinerary = await supabase
            .from('Itinerary')
            .insert({
              'trip_id': newTripId,
              'itinerary_date': old['itinerary_date'],
            })
            .select()
            .single();

        final newItineraryId = newItinerary['itinerary_id'];

        final details = await supabase
            .from('ItineraryDetails')
            .select()
            .eq('itinerary_id', old['itinerary_id']);

        for (final detail in details) {
          await supabase.from('ItineraryDetails').upsert({
            'itinerary_id': newItineraryId,
            'details_name': detail['details_name'],
            'custom_notes': detail['custom_notes'],
            'preferred_time': detail['preferred_time'],
          });
        }
      }

      print("▶️ Step 5: Cloning things to carry");
      // Step 5: Clone things to carry
      final thingsCarry = await supabase
          .from('things_to_carry')
          .select()
          .eq('trip_id', originalTripId);

      for (final item in thingsCarry) {
        await supabase.from('things_to_carry').upsert({
          'trip_id': newTripId,
          'carry_item': item['carry_item'],
        });
      }


      print("▶️ Step 6: Remove bookmark after cloning");
      await supabase
          .from('Bookmark')
          .delete()
          .eq('user_id', userId)
          .eq('template_id', templateId);

      setState(() {
        isBookmarked = false;
      });

      print("✅ All cloning complete.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Trip itinerary added to My Trips")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MyTripTemplateView(
            tripID: newTripId,
            title: newTrip['trip_name'],
            image: newTrip['cover_photo_url'] ?? '',
            location: newTrip['city_location'],
          ),
        ),
      );
    } catch (e, stack) {
      print("Error during trip cloning: $e");
      print(stack);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to get trip itinerary.")),
      );
    }
  }

  Future<void> _fetchTripDetails() async {
    try {
      final supabase = Supabase.instance.client;

      // Fetch Template Description
      final templateResponse = await supabase
          .from('Template')
          .select('template_description')
          .eq('template_id', widget.templateID)
          .maybeSingle();

      // Fetch Trip Budget
      final tripResponse = await supabase
          .from('Trip')
          .select('trip_budget')
          .eq('trip_id', widget.tripID)
          .maybeSingle();

      setState(() {
        templateDescription = templateResponse != null &&
                templateResponse['template_description'] != null
            ? templateResponse['template_description']
            : "No description available.";

        budgetRange =
            tripResponse != null && tripResponse['trip_budget'] != null
                ? tripResponse['trip_budget']
                : "Budget not available";
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching trip details: $e');
      setState(() {
        templateDescription = "Unable to load description.";
        budgetRange = "Unavailable";
        isLoading = false;
      });
    }
  }

  double? lerpDouble(double a, double b, double t) {
    return a + (b - a) * t.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final double minTop = screenHeight * 0.4 + 50;
    final double maxTop = screenHeight * 0.15;
    final double topOffset =
        lerpDouble(minTop, maxTop, (_sheetExtent - 0.4) / (0.85 - 0.4))!;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          SizedBox(
            height: 500,
            width: double.infinity,
            child: widget.image.isNotEmpty
                ? Image.asset(widget.image, fit: BoxFit.cover)
                : Container(
                    color: const Color.fromRGBO(111, 111, 111, 1),
                    alignment: Alignment.center,
                    child: const Text("No Image"),
                  ),
          ),

          // Back Button
          Positioned(
            top: 40,
            left: 10,
            child: ArrowBackButton(),
          ),

          // Title and Location
          Positioned(
            left: 30,
            top: topOffset,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sofia_Sans',
                    ),
                  ),
                  width: 320,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_pin,
                        color: Color.fromRGBO(0, 157, 192, 1), size: 16),
                    const SizedBox(width: 4),
                    Text(
                      widget.location,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Sofia_Sans',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Scroll Sheet
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              setState(() {
                _sheetExtent = notification.extent;
              });
              return true;
            },
            child: DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.4,
              maxChildSize: 0.85,
              builder: (context, scrollController) {
                return Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Trip Budget",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontFamily: "Sofia_Sans")),
                                  IconButton(
                                    onPressed: _toggleBookmark,
                                    icon: Icon(
                                      isBookmarked
                                          ? Icons.bookmark
                                          : Icons.bookmark_border,
                                      color:
                                          const Color.fromRGBO(0, 157, 192, 1),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                budgetRange,
                                style: const TextStyle(
                                  color: Color.fromRGBO(53, 50, 66, 1),
                                  fontSize: 20,
                                  fontFamily: 'Sofia_Sans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                templateDescription,
                                style: lightGrey_paragraph_text,
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                );
              },
            ),
          ),

          // Fixed Bottom Button
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: active_button_blue(
              onPress: () async {
                await cloneTemplateTripToUser(
                  templateId: widget.templateID, // your resolved template ID
                  context: context,
                );
              },
              buttonLabel: Text(
                "Get Trip Itinerary",
                style: active_button_text_blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
