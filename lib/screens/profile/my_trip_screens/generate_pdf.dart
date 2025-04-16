import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> checkAndRequestStoragePermission(BuildContext context) async {
  if (Platform.isAndroid) {
    var status = await Permission.manageExternalStorage.status;

    if (status.isPermanentlyDenied) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Storage Permission Required"),
          content: const Text(
              "To save the itinerary PDF, we need storage access. Please enable it in app settings."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                openAppSettings();
                Navigator.pop(context);
              },
              child: const Text("Open Settings"),
            ),
          ],
        ),
      );
      return false;
    }

    if (!status.isGranted) {
      final result = await Permission.manageExternalStorage.request();
      if (!result.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Storage permission is required.")),
        );
        return false;
      }
    }
  }
  print(await Permission.manageExternalStorage.status);
  return true;
}

Future<void> generateItineraryPdf(final tripId, BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      content: Row(
        children: const [
          CircularProgressIndicator(),
          SizedBox(width: 20),
          Expanded(child: Text("Generating PDF...")),
        ],
      ),
    ),
  );

  try {
    // Check permission first
    bool permissionGranted = await checkAndRequestStoragePermission(context);
    if (!permissionGranted) {
      Navigator.pop(context);
      return;
    }

    final pdf = pw.Document();

    // Fetch Trip info
    final tripResList = await Supabase.instance.client
        .from('Trip')
        .select('trip_name, start_date, end_date')
        .eq('trip_id', tripId);

    if (tripResList == null || tripResList.isEmpty) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Trip not found.")),
      );
      return;
    }

    final tripRes = tripResList[0];
    final tripName = tripRes['trip_name'].toString();
    final startDate = DateTime.parse(tripRes['start_date']);
    final endDate = DateTime.parse(tripRes['end_date']);

    // Generate full date list
    List<DateTime> fullDateList = [];
    for (DateTime d = startDate; !d.isAfter(endDate); d = d.add(Duration(days: 1))) {
      fullDateList.add(d);
    }

    // Fetch itinerary
    final itineraryRes = await Supabase.instance.client
        .from('Itinerary')
        .select('itinerary_id, itinerary_date, ItineraryDetails(*)')
        .eq('trip_id', tripId)
        .order('itinerary_date', ascending: true);

    final itineraryMap = {
      for (var day in itineraryRes)
        DateTime.parse(day['itinerary_date']).toIso8601String(): day
    };

    // Fetch carry items
    final carryResList = await Supabase.instance.client
        .from('things_to_carry')
        .select()
        .eq('trip_id', tripId)
        .limit(1);

    final carryRes = carryResList.isNotEmpty ? carryResList[0] : null;

    List<String> carryItems = [];
    if (carryRes != null && carryRes['carry_item'] != null) {
      carryItems = List<String>.from(
        carryRes['carry_item'] is String
            ? List<String>.from((carryRes['carry_item'] as String)
            .replaceAll('[', '')
            .replaceAll(']', '')
            .split(',')
            .map((e) => e.trim()))
            : carryRes['carry_item'],
      );
    }

    // Build PDF
    pdf.addPage(pw.MultiPage(
      build: (context) => [
        pw.Text('Trip: $tripName', style: pw.TextStyle(fontSize: 24)),
        pw.SizedBox(height: 16),
        pw.Text("Itinerary", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 10),
        ...fullDateList.asMap().entries.map((entry) {
          final i = entry.key;
          final date = entry.value;
          final isoDate = date.toIso8601String();
          final formattedDate = DateFormat('dd MMM yyyy').format(date);

          final item = itineraryMap[isoDate];
          final details = item != null
              ? List<Map<String, dynamic>>.from(item['ItineraryDetails'])
              : [];

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Day ${i + 1} - $formattedDate",
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 6),
              if (details.isEmpty) pw.Text("No activities planned."),
              ...details.map((detail) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 8),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (detail['preferred_time'] != null)
                      pw.Text("Time: ${detail['preferred_time']}"),
                    pw.Text(" ${detail['details_name']}"),
                    if (detail['custom_notes'] != null &&
                        detail['custom_notes'].toString().isNotEmpty)
                      pw.Text("Note: ${detail['custom_notes']}"),
                  ],
                ),
              ))
            ],
          );
        }),
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Text("Things to Carry",
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        if (carryItems.isEmpty) pw.Text("No items listed."),
        if (carryItems.isNotEmpty) pw.Bullet(text: carryItems.join('\n')),
      ],
    ));

    // Save to Downloads folder
    final fileName = 'Itinerary_${tripName.replaceAll(" ", "_")}.pdf';
    final downloadsDir = Directory('/storage/emulated/0/Download');

    if (!downloadsDir.existsSync()) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Downloads folder not found.")),
      );
      return;
    }

    final file = File('${downloadsDir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ PDF saved to Downloads! Opening...")),
    );

    await OpenFilex.open(file.path);
  } catch (e) {
    print(e);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ Error: $e")),
    );
  }
}
