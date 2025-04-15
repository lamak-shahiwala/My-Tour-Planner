import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:my_tour_planner/screens/home/trip_template_view.dart';

class BookmarkTab extends StatefulWidget {
  const BookmarkTab({super.key});

  @override
  State<BookmarkTab> createState() => _BookmarkTabState();
}

class _BookmarkTabState extends State<BookmarkTab> {
  final supabase = Supabase.instance.client;
  bool isLoading = true;
  List<Map<String, dynamic>> bookmarkedTemplates = [];

  @override
  void initState() {
    super.initState();
    fetchBookmarkedTemplates();
  }

  Future<void> fetchBookmarkedTemplates() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    final response = await supabase
        .from('Bookmark')
        .select(
            'template_id, Template(template_id, trip_id, Trip(trip_name, cover_photo_url, city_location))')
        .eq('user_id', userId);

    final List<Map<String, dynamic>> results = [];

    for (final item in response) {
      final template = item['Template'];
      final trip = template['Trip'];

      results.add({
        'title': trip['trip_name'] ?? '',
        'image': trip['cover_photo_url'] ?? '',
        'location': trip['city_location'] ?? '',
        'trip_id': template['trip_id'],
        'template_id': template['template_id'],
      });
    }

    setState(() {
      bookmarkedTemplates = results;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (bookmarkedTemplates.isEmpty) {
      return const Center(child: Text("No bookmarks yet."));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        childAspectRatio: 0.85,
      ),
      itemCount: bookmarkedTemplates.length,
      itemBuilder: (context, index) {
        final template = bookmarkedTemplates[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TripTemplateView(
                  title: template['title'],
                  image: template['image'],
                  location: template['location'],
                  tripID: template['trip_id'],
                  templateID: template['template_id'],
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                template['image'] != ''
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          template['image'],
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromRGBO(111, 111, 111, 1),
                        ),
                        alignment: Alignment.center,
                        child: const Text("No Image"),
                      ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        template['title'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        template['location'],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
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
