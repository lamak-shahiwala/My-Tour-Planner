import 'package:flutter/material.dart';
import 'package:my_tour_planner/utilities/button/arrow_back_button.dart';
import 'package:my_tour_planner/utilities/button/button.dart';
import 'package:my_tour_planner/utilities/text/text_styles.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchTripDetails();
  }

  Future<void> _fetchTripDetails() async {
    try {
      final supabase = Supabase.instance.client;

      // Fetch Template Description
      final templateResponse = await supabase
          .from('Template')
          .select('template_description')
          .eq('template_id', widget.templateID)
          .single();

      // Fetch Trip Budget
      final tripResponse = await supabase
          .from('Trip')
          .select('trip_budget')
          .eq('trip_id', widget.tripID)
          .single();

      setState(() {
        templateDescription = templateResponse['template_description'] ?? '';
        budgetRange = tripResponse['trip_budget'] ?? 'Budget not available';
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
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Sofia_Sans',
                  ),
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
                              onPressed: () {},
                              icon: const Icon(Icons.bookmark_border,
                                  color:
                                  Color.fromRGBO(0, 157, 192, 1)),
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
              onPress: () {},
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


