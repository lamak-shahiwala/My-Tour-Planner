// // testing is completed , but only save button is remaining
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_tour_planner/screens/home/home.dart';
import 'package:my_tour_planner/screens/profile/my_trip_screens/my_trip_things_to_carry.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      'details_name': name,
      'custom_notes': note,
      'preferred_time': time != null
          ? '${time!.hour.toString().padLeft(2, '0')}:${time!.minute.toString().padLeft(2, '0')}'
          : null,
      'itinerary_id': itinerary_id,
    };
  }
}

class MyTripEditItineraryScreen extends StatefulWidget {
  final trip_id;

  const MyTripEditItineraryScreen({super.key, required this.trip_id});

  @override
  State<MyTripEditItineraryScreen> createState() =>
      _MyTripEditItineraryScreenState();
}

class _MyTripEditItineraryScreenState extends State<MyTripEditItineraryScreen> {
  final List<DateTime> dateList = [];
  final List<List<ItineraryDetail>> itineraryPerDate = [];
  bool isEditMode = false;
  String tripName = '';
  List<Map<String, dynamic>> thingsToCarry = [];
  bool isLoadingThings = true;
  late TextEditingController _tripNameController;

  @override
  void initState() {
    super.initState();
    _tripNameController = TextEditingController();
    _fetchTripName();
    _fetchItinerary();
    // _fetchThingsToCarry();
  }

  Future<void> _fetchTripName() async {
    final response = await Supabase.instance.client
        .from('Trip')
        .select('trip_name')
        .eq('trip_id', widget.trip_id)
        .single();

    setState(() {
      tripName = response['trip_name'] ?? 'Trip';
      _tripNameController.text = tripName;
    });
  }

  Future<void> _fetchItinerary() async {
    final response = await Supabase.instance.client
        .from('Itinerary')
        .select('itinerary_id, itinerary_date, ItineraryDetails(*)')
        .eq('trip_id', widget.trip_id)
        .order('itinerary_date', ascending: true);

    final List data = response;
    for (var day in data) {
      final date = DateTime.parse(day['itinerary_date']);
      final List<ItineraryDetail> details = [];

      for (var d in day['ItineraryDetails']) {
        final time = d['preferred_time'] != null
            ? TimeOfDay(
                hour: int.parse(d['preferred_time'].split(":")[0]),
                minute: int.parse(d['preferred_time'].split(":")[1]),
              )
            : null;

        details.add(ItineraryDetail(
          itinerary_id: day['itinerary_id'],
          details_id: d['details_id'],
          name: d['details_name'] ?? '',
          note: d['custom_notes'] ?? '',
          time: time,
        ));
      }

      dateList.add(date);
      itineraryPerDate.add(details);
    }
    setState(() {});
  }

  Future<void> _fetchThingsToCarry() async {
    try {
      final response = await Supabase.instance.client
          .from('things_to_carry')
          .select('*')
          .eq('trip_id', widget.trip_id);

      setState(() {
        thingsToCarry = List<Map<String, dynamic>>.from(response);
        isLoadingThings = false;
      });
    } catch (e) {
      print('Error loading things to carry: $e');
      setState(() {
        isLoadingThings = false;
      });
    }
  }

  Future<void> _saveChanges() async {
    // Updating Trip Name
    if (_tripNameController.text.trim().isNotEmpty &&
        _tripNameController.text.trim() != tripName) {
      await Supabase.instance.client
          .from('Trip')
          .update({'trip_name': _tripNameController.text.trim()}).eq(
              'trip_id', widget.trip_id);
      setState(() {
        tripName = _tripNameController.text.trim();
      });
    }

    // Save itinerary changes
    for (var details in itineraryPerDate) {
      for (var d in details) {
        if (d.details_id != null) {
          await Supabase.instance.client
              .from('ItineraryDetails')
              .update(d.toMap())
              .eq('details_id', d.details_id!);
        } else {
          await Supabase.instance.client
              .from('ItineraryDetails')
              .insert(d.toMap());
        }
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Itinerary saved')),
    );

    //  Navigate back to Home
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  Widget _tripTemplate(int index) {
    final date = dateList[index];
    final formattedDate = DateFormat('dd MMM yyyy').format(date);
    final details = itineraryPerDate[index];

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Day ${index + 1}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(formattedDate)
              ],
            ),
            const SizedBox(height: 10),
            ...details.asMap().entries.map((entry) {
              final detailIndex = entry.key;
              final detail = entry.value;
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      if (isEditMode)
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Delete Detail"),
                                  content: const Text(
                                      "Are you sure you want to delete this detail?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text("Delete",
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                if (detail.details_id != null) {
                                  // Delete from Supabase
                                  await Supabase.instance.client
                                      .from('ItineraryDetails')
                                      .delete()
                                      .eq('details_id', detail.details_id!);
                                }
                                setState(() {
                                  itineraryPerDate[index].removeAt(detailIndex);
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Detail deleted")),
                                );
                              }
                            },
                          ),
                        ),
                      TextFormField(
                        readOnly: true,
                        controller: TextEditingController(
                          text: detail.time != null
                              ? detail.time!.format(context)
                              : '',
                        ),
                        decoration:
                            const InputDecoration(labelText: 'Preferred Time'),
                        onTap: isEditMode
                            ? () async {
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: detail.time ?? TimeOfDay.now(),
                                );
                                if (picked != null) {
                                  setState(() => detail.time = picked);
                                }
                              }
                            : null,
                      ),
                      TextFormField(
                        initialValue: detail.name,
                        readOnly: !isEditMode,
                        decoration:
                            const InputDecoration(labelText: 'Detail Name'),
                        onChanged: (val) => detail.name = val,
                      ),
                      TextFormField(
                        initialValue: detail.note,
                        readOnly: !isEditMode,
                        decoration:
                            const InputDecoration(labelText: 'Custom Notes'),
                        onChanged: (val) => detail.note = val,
                      ),
                    ],
                  ),
                ),
              );
            }),
            if (isEditMode)
              TextButton.icon(
                onPressed: () {
                  final itineraryId = itineraryPerDate[index].isNotEmpty
                      ? itineraryPerDate[index].first.itinerary_id
                      : null;

                  setState(() => itineraryPerDate[index].add(
                        ItineraryDetail(itinerary_id: itineraryId),
                      ));
                },
                icon: const Icon(Icons.add),
                label: const Text("Add Detail"),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildThingsToCarry() {
    return FutureBuilder(
      future: Supabase.instance.client
          .from('things_to_carry')
          .select('*')
          .eq('trip_id', widget.trip_id)
          .maybeSingle(), // We expect one record per trip
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Text("Failed to load things to carry.");
        }
        if (snapshot.data == null) {
          return const Text("No items yet.");
        }

        // Assuming snapshot.data is a Map<String, dynamic>
        final data = snapshot.data as Map<String, dynamic>;
        final List<dynamic> carryItems = data['carry_item'] != null
            ? jsonDecode(data['carry_item']) as List<dynamic>
            : [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Things to Carry:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...carryItems.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final item = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text("$index. $item"),
              );
            }),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: () async {
                final newItem = await showDialog<String>(
                  context: context,
                  builder: (context) {
                    String inputText = "";
                    return AlertDialog(
                      title: const Text("Add New Item"),
                      content: TextField(
                        autofocus: true,
                        decoration:
                            const InputDecoration(hintText: "Enter item name"),
                        onChanged: (value) {
                          inputText = value;
                        },
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(inputText),
                          child: const Text("Add"),
                        ),
                      ],
                    );
                  },
                );

                if (newItem != null && newItem.trim().isNotEmpty) {
                  try {
                    // Fetch the current record
                    final currentResponse = await Supabase.instance.client
                        .from('things_to_carry')
                        .select('*')
                        .eq('trip_id', widget.trip_id)
                        .single();

                    final currentData = currentResponse as Map<String, dynamic>;
                    final List<dynamic> currentItems =
                        currentData['carry_item'] != null
                            ? jsonDecode(currentData['carry_item'])
                                as List<dynamic>
                            : [];

                    // Add the new item
                    currentItems.add(newItem.trim());

                    // Update the record
                    await Supabase.instance.client
                        .from('things_to_carry')
                        .update({'carry_item': jsonEncode(currentItems)}).eq(
                            'trip_id', widget.trip_id);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Item added!")),
                    );

                    setState(() {}); // Refresh UI
                  } catch (e) {
                    print("Error while adding item: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Error adding item.")),
                    );
                  }
                }
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Item"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: isEditMode
              ? SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _tripNameController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: "Enter Trip Name : ",
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Text(tripName),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ...List.generate(dateList.length, _tripTemplate),
            ThingsToCarryWidget(tripId: widget.trip_id),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => isEditMode = true),
                  child: const Text("Edit"),
                ),
                ElevatedButton(
                  onPressed: _saveChanges,
                  child: const Text("Save"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
