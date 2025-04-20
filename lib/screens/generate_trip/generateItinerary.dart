import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../backend/classes.dart';
import '../../backend/db_methods.dart';
import '../create_trip/edit_itinerary.dart';

class CreateTripFlow extends StatefulWidget {
  final int tripId;
  final String location;
  final String tripType;
  final String startDate;
  final String endDate;
  final String budget;

  const CreateTripFlow({
    super.key,
    required this.tripId,
    required this.location,
    required this.tripType,
    required this.startDate,
    required this.endDate,
    required this.budget,
  });

  @override
  State<CreateTripFlow> createState() => _CreateTripFlowState();
}

class _CreateTripFlowState extends State<CreateTripFlow> {
  final itineraryDb = ItineraryDatabase();
  final thingsDb = ThingsCarryDB();

  @override
  void initState() {
    super.initState();
    _handleGeneration();
  }

  Future<void> _handleGeneration() async {
    try {
      final response = await callBackendToGenerateTrip({
        "trip_type": widget.tripType,
        "city_location": widget.location,
        "start_date": widget.startDate.split(" ")[0],
        "end_date": widget.endDate.split(" ")[0],
        "budget_range": widget.budget,
      });

      if (response.containsKey("error")) {
        throw Exception(response['error']);
      }

      final itinerary = response['itinerary'] as List<dynamic>;
      final carryItems = response['carry_items'] as List<dynamic>;

      for (final day in itinerary) {
        final date = day['date'] as String;
        final details = day['details'] as List<dynamic>;

        print("Processing itinerary for $date");

        final itineraryId = await itineraryDb.addItinerary(Itinerary(
          trip_id: widget.tripId,
          itinerary_date: date,
        ));

        for (final detail in details) {
          print("Processing detail: $detail");

          final rawName = detail['details_name'] ?? '';
          final rawNotes = detail['custom_notes'] ?? '';
          final rawTime = detail['preferred_time'] ?? '';

          // Clean data
          final cleanedName = rawName.toString().replaceAll(RegExp(r'\*'), '').trim();
          final cleanedNotes = rawNotes.toString().replaceAll(RegExp(r'\*'), '').trim();
          final cleanedTime = rawTime.toString().replaceAll(RegExp(r'\*'), '').trim();

          // Time formatting to 24-hour format
          String? formattedTime;
          try {
            if (rawTime.toString().isNotEmpty) {
              final timeString = rawTime.toString().replaceAll(RegExp(r'\*'), '').trim();
              final parsedTime = DateFormat("h:mm a").parse(timeString);
              formattedTime = DateFormat("HH:mm").format(parsedTime);
            }
          } catch (e) {
            print("Invalid time format for '$rawTime' on $date: $e");
          }

          if (cleanedName.isNotEmpty && cleanedNotes.isNotEmpty && formattedTime != null) {
            await itineraryDb.addItineraryDetails(ItineraryDetails(
              itinerary_id: itineraryId,
              details_name: cleanedName,
              custom_notes: cleanedNotes,
              preferred_time: formattedTime,
            ));
          } else {
            print("Invalid data for day $date: $detail");
          }
        }
      }

      await thingsDb.addCarryItem(Things_Carry(
        trip_id: widget.tripId,
        carry_item: List<String>.from(carryItems),
      ));

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EditItineraryScreen(trip_id: widget.tripId),
          ),
        );
      }
    } catch (e) {
      print("Error generating trip: $e");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: const Text("An error occurred while generating the trip. Please try again later."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  Future<Map<String, dynamic>> callBackendToGenerateTrip(Map<String, dynamic> tripData) async {
    try {
      final response = await http.post(
        Uri.parse("https://mytourplanner92.pythonanywhere.com/generate-trip"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(tripData),
      ).timeout(const Duration(seconds: 120));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Failed to generate trip: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to generate trip");
      }
    } catch (e) {
      print("Error generating trip: $e");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
