import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditItinerary extends StatefulWidget {
  final trip_id;

  const EditItinerary({Key? key, required this.trip_id}) : super(key: key);

  @override
  State<EditItinerary> createState() => _EditItineraryState();
}

class ItineraryDetail {
  int? itinerary_id;
  int? details_id;
  String name;
  String note;
  TimeOfDay? time;

  ItineraryDetail({
    this.itinerary_id,
    this.details_id,
    this.name = '',
    this.note = '',
    this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'details_id': details_id,
      'itinerary_id': itinerary_id,
      'details_name': name,
      'custom_notes': note,
      'preferred_time': time != null
          ? '${time!.hour.toString().padLeft(2, '0')}:${time!.minute.toString().padLeft(2, '0')}'
          : null,
    };
  }
}

class _EditItineraryState extends State<EditItinerary> {
  final List<DateTime> dateList = [];
  final List<List<ItineraryDetail>> itineraryPerDate = [];

  bool isLoading = true;
  bool isEditMode = false;
  String tripName = '';

  @override
  void initState() {
    super.initState();
    _fetchTripName();
    _fetchItineraries();
  }

  Future<void> _fetchTripName() async {
    final response = await Supabase.instance.client
        .from('Trip')
        .select('trip_name')
        .eq('trip_id', widget.trip_id)
        .single();

    setState(() {
      tripName = response['trip_name'] ?? 'Trip';
    });
  }

  Future<void> _fetchItineraries() async {
    final response = await Supabase.instance.client
        .from('Itinerary')
        .select('itinerary_id, itinerary_date, ItineraryDetails(*)')
        .eq('trip_id', widget.trip_id)
        .order('itinerary_date', ascending: true);

    final List data = response;

    for (var row in data) {
      final date = DateTime.parse(row['itinerary_date']);
      final List<ItineraryDetail> details = [];

      for (var d in row['ItineraryDetails']) {
        final time = d['preferred_time'] != null
            ? TimeOfDay(
                hour: int.parse(d['preferred_time'].split(":")[0]),
                minute: int.parse(d['preferred_time'].split(":")[1]),
              )
            : null;

        details.add(ItineraryDetail(
          itinerary_id: row['itinerary_id'],
          details_id: d['details_id'],
          name: d['details_name'] ?? '',
          note: d['custom_notes'] ?? '',
          time: time,
        ));
      }

      dateList.add(date);
      itineraryPerDate.add(details);
    }

    setState(() => isLoading = false);
  }

  Future<void> _saveChanges() async {
    final client = Supabase.instance.client;
    for (var dailyDetails in itineraryPerDate) {
      for (var detail in dailyDetails) {
        await client
            .from('ItineraryDetails')
            .update(detail.toMap())
            .eq('details_id', detail.details_id!);
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Changes saved.")),
    );

    setState(() => isEditMode = false);
  }

  Widget _tripTemplate(int index) {
    final date = dateList[index];
    final formattedDate = DateFormat("dd MMM yyyy").format(date);
    final details = itineraryPerDate[index];

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Day ${index + 1}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(formattedDate),
              ],
            ),
            SizedBox(height: 8.0),
            ...details.map((detail) => Column(
                  children: [
                    TextFormField(
                      initialValue: detail.name,
                      readOnly: !isEditMode,
                      decoration:
                          InputDecoration(labelText: "Trip Detail Name"),
                      onChanged: (value) => detail.name = value,
                    ),
                    TextFormField(
                      initialValue: detail.note,
                      readOnly: !isEditMode,
                      decoration: InputDecoration(labelText: "Notes"),
                      onChanged: (value) => detail.note = value,
                    ),
                    GestureDetector(
                      onTap: isEditMode
                          ? () async {
                              final picked = await showTimePicker(
                                  context: context,
                                  initialTime: detail.time ?? TimeOfDay.now());
                              if (picked != null) {
                                setState(() {
                                  detail.time = picked;
                                });
                              }
                            }
                          : null,
                      child: AbsorbPointer(
                        absorbing: true,
                        child: TextFormField(
                          controller: TextEditingController(
                            text: detail.time != null
                                ? detail.time!.format(context)
                                : '',
                          ),
                          decoration: InputDecoration(
                            labelText: "Time ",
                          ),
                          readOnly: true,
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tripName),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  ...List.generate(dateList.length, _tripTemplate),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () => setState(() => isEditMode = true),
                          child: const Text("Edit")),
                      ElevatedButton(
                          onPressed: isEditMode ? _saveChanges : null,
                          child: const Text("Save")),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
