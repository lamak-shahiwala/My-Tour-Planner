import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

String normalizeDate(DateTime dt) => DateFormat('yyyy-MM-dd').format(dt);

Future<bool> checkAndRequestStoragePermission(BuildContext context) async {
  if (Platform.isAndroid) {
    final int sdkInt = int.tryParse(Platform.version.split(' ').first) ?? 0;

    if (sdkInt >= 30) {
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
            const SnackBar(content: Text("Storage permission is required.")),
          );
          return false;
        }
      }
    } else {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        final result = await Permission.storage.request();
        if (!result.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Storage permission is required.")),
          );
          return false;
        }
      }
    }
  }
  return true;
}

pw.Widget _buildDottedLine() {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.center,
    children: List.generate(50, (index) {
      return index % 2 == 0
          ? pw.Container(width: 2, height: 1)
          : pw.SizedBox(width: 3);
    }),
  );
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
    bool permissionGranted = await checkAndRequestStoragePermission(context);
    if (!permissionGranted) {
      Navigator.pop(context);
      return;
    }

    final pdf = pw.Document();
    final imageBytes = await rootBundle.load('assets/images/MTP_App_Icon.png');
    final image = pw.MemoryImage(imageBytes.buffer.asUint8List());

    final tripResList = await Supabase.instance.client
        .from('Trip')
        .select('trip_name, start_date, end_date')
        .eq('trip_id', tripId);

    if (tripResList.isEmpty) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Trip not found")),
      );
      return;
    }

    final tripRes = tripResList[0];
    final tripName = tripRes['trip_name'].toString();
    final startDate = DateTime.parse(tripRes['start_date']);
    final endDate = DateTime.parse(tripRes['end_date']);

    List<DateTime> fullDateList = [];
    for (DateTime d = startDate;
        !d.isAfter(endDate);
        d = d.add(Duration(days: 1))) {
      fullDateList.add(d);
    }

    final itineraryRes = await Supabase.instance.client
        .from('Itinerary')
        .select('itinerary_date, ItineraryDetails(*)')
        .eq('trip_id', tripId)
        .order('itinerary_date', ascending: true);

    final itineraryMap = {
      for (var day in itineraryRes)
        normalizeDate(DateTime.parse(day['itinerary_date'])): day
    };

    final carryResList = await Supabase.instance.client
        .from('things_to_carry')
        .select()
        .eq('trip_id', tripId)
        .limit(1);

    final carryRes = carryResList.isNotEmpty ? carryResList[0] : null;

    List<String> carryItems = [];
    if (carryRes != null && carryRes['carry_item'] != null) {
      final item = carryRes['carry_item'];
      if (item is List) {
        carryItems = List<String>.from(item);
      } else if (item is String) {
        carryItems = item
            .replaceAll(RegExp(r'[\[\]]'), '')
            .split(',')
            .map((e) => e.trim())
            .toList();
      }
    }

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          buildBackground: (context) => pw.FullPage(
            ignoreMargins: true,
            child: pw.Opacity(
              opacity: 0.08,
              child: pw.Image(image, fit: pw.BoxFit.cover),
            ),
          ),
        ),
        build: (context) => [
          pw.Text('Itinerary: $tripName',
              style:
                  pw.TextStyle(fontSize: 32, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 25),
          ...fullDateList.asMap().entries.expand((entry) {
            final i = entry.key;
            final date = entry.value;
            final formattedDate = DateFormat('dd MMM yyyy').format(date);
            final dayData = itineraryMap[normalizeDate(date)];

            final details = dayData != null
                ? List<Map<String, dynamic>>.from(dayData['ItineraryDetails'])
                : [];

            return [
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Day ${i + 1}",
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    pw.Text("[$formattedDate]",
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  ]),
              pw.SizedBox(height: 6),
              if (details.isEmpty) pw.Text("No activities planned."),
              ...details.map((detail) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 8),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        if (detail['preferred_time'] != null)
                          pw.Text("Time: ${detail['preferred_time']}"),
                        pw.Text("${detail['details_name']}"),
                        if (detail['custom_notes'] != null &&
                            detail['custom_notes'].toString().isNotEmpty)
                          pw.Text("Note: ${detail['custom_notes']}"),
                      ],
                    ),
                  )),
              if (i < fullDateList.length - 1) ...[
                pw.SizedBox(height: 10),
                _buildDottedLine(),
                pw.SizedBox(height: 10),
              ],
            ];
          }),
          pw.Divider(),
          pw.SizedBox(height: 10),
          pw.Text("Things to Carry",
              style:
                  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          if (carryItems.isEmpty) pw.Text("No items listed."),
          if (carryItems.isNotEmpty)
            ...carryItems.map((item) => pw.Bullet(text: item)).toList(),
        ],
      ),
    );

    final fileName = 'Itinerary_${tripName.replaceAll(" ", "_")}.pdf';
    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cannot access storage directory.")),
      );
      return;
    }

    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("PDF saved to Downloads! Opening...")),
    );

    await OpenFilex.open(file.path);
  } catch (e) {
    debugPrint("PDF generation error: $e");
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Something went wrong. Please try again.")),
    );
  }
}
