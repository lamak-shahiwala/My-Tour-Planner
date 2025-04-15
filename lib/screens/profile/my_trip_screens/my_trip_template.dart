import 'package:flutter/material.dart';
import 'package:my_tour_planner/screens/profile/my_trip_screens/my_trip_edit_itinerary.dart';
import 'package:my_tour_planner/utilities/button/arrow_back_button.dart';
import 'package:my_tour_planner/utilities/button/button.dart';
import 'package:my_tour_planner/utilities/text/text_styles.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyTripTemplateView extends StatefulWidget {
  const MyTripTemplateView({
    super.key,
    required this.title,
    required this.image,
    required this.location,
    required this.tripID,
  });

  final tripID;
  final String title;
  final String image;
  final String location;

  @override
  State<MyTripTemplateView> createState() => _TripTemplateViewState();
}

class _TripTemplateViewState extends State<MyTripTemplateView> {
  double _sheetExtent = 0.4;
  late final budgetRange;
  bool isLoading = true;

  // late String templateDescription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchBudget(widget.tripID);
    // _fetchTemplateDescription(widget.tripID);
  }

  // Future<void> _fetchTemplateDescription(final tripId) async {
  //   try {
  //     final response = await Supabase.instance.client
  //         .from('Template')
  //         .select('template_description')
  //         .eq('trip_id', tripId)
  //         .single();
  //
  //     setState(() {
  //       templateDescription =
  //           response['template_description'] ?? 'No Description';
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     print("Error fetching Template Description: $e");
  //     setState(() {
  //       templateDescription = "Error loading description ";
  //       isLoading = false;
  //     });
  //   }
  // }

  Future<void> _fetchBudget(final tripId) async {
    try {
      final response = await Supabase.instance.client
          .from('Trip')
          .select('trip_budget')
          .eq('trip_id', tripId)
          .single();

      setState(() {
        budgetRange = response['trip_budget'] ?? "Not specified";
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching budget: $e");
      setState(() {
        budgetRange = "Error loading budget";
        isLoading = false;
      });
    }
  }

  Future<void> _deleteTrip(final tripId) async {
    try {
      final response = await Supabase.instance.client
          .from('Trip')
          .delete()
          .eq('trip_id', tripId);

      print("Trip deleted successfully");
    } catch (e) {
      print("Error deleting trip: $e");
    }
  }

  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // Dynamically calculate top offset for title based on sheet position
    final double minTop = screenHeight * 0.4 + 50; // at initial extent
    final double maxTop = screenHeight * 0.15; // how far up it can go
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
                ? widget.image.contains("assets/images/template_covers/")
                    ? Image.asset(widget.image, fit: BoxFit.cover)
                    : Image.network(widget.image, fit: BoxFit.cover)
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

          // Scroll Sheet with NotificationListener
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
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Trip Budget",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                    fontFamily: "Sofia_Sans")),
                            IconButton(
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Delete Trip"),
                                    content: const Text(
                                        "Are you sure you want to delete this trip? This action cannot be undone."),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  178, 60, 50, 1)),
                                        ),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  try {
                                    // Delete the trip (and related records if needed)
                                    await Supabase.instance.client
                                        .from('Trip')
                                        .delete()
                                        .eq('trip_id', widget.tripID);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("Trip deleted successfully"),
                                      ),
                                    );

                                    setState(() {});
                                  } catch (e) {
                                    print("Delete error: $e");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Failed to delete trip"),
                                      ),
                                    );
                                  }
                                }
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Color.fromRGBO(178, 60, 50, 1),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 4),
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Text(
                                budgetRange,
                                style: const TextStyle(
                                  color: Color.fromRGBO(53, 50, 66, 1),
                                  fontSize: 20,
                                  fontFamily: 'Sofia_Sans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                        //   const SizedBox(height: 20),
                        //   Text(
                        //     templateDescription,
                        //     style: lightGrey_paragraph_text,
                        //   ),
                        //   const SizedBox(height: 40),
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
                  onPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyTripEditItineraryScreen(
                                trip_id: widget.tripID)));
                  },
                  buttonLabel: Text(
                    "Edit/View Itinerary",
                    style: active_button_text_blue,
                  ))),
        ],
      ),
    );
  }

  double? lerpDouble(double a, double b, double t) {
    return a + (b - a) * t.clamp(0.0, 1.0);
  }
}
