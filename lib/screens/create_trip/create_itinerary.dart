/*

This file contains code of create Itinerary

pending work:
- custom TextFormFields and Time Fields

*/


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_tour_planner/utilities/text/text_styles.dart';
import 'package:my_tour_planner/utilities/text_field/Itinerary_detail_name__textfield.dart';
import 'package:my_tour_planner/utilities/text_field/expandable_custom_itinerary_note__textfield.dart';
import '../../../utilities/button/save_next_button.dart';
import 'package:my_tour_planner/utilities/button/arrow_back_button.dart';
import 'add_things_to_carry.dart';

class ItineraryDetail {
  String name = '';
  String note = '';
  TimeOfDay? time;

  ItineraryDetail();
}

class CreateItinerary extends StatefulWidget {
  const CreateItinerary({
    Key? key,
    required this.startDate,
    required this.endDate,
    required this.trip_name,
    required this.location_name,
    required this.trip_type,
  }) : super(key: key);

  final DateTime? startDate;
  final DateTime? endDate;
  final String trip_name;
  final String location_name;
  final String trip_type;

  @override
  State<CreateItinerary> createState() => _CreateItineraryState();
}

class _CreateItineraryState extends State<CreateItinerary> {
  List<DateTime> dateList = [];
  List<List<ItineraryDetail>> itineraryPerDate = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _generateDateFields();
  }

  void _generateDateFields() {
    if (widget.startDate != null && widget.endDate != null) {
      final start = widget.startDate!;
      final end = widget.endDate!;

      for (DateTime date = start;
      !date.isAfter(end);
      date = date.add(Duration(days: 1))) {
        dateList.add(date);
        itineraryPerDate.add([ItineraryDetail()]);
      }
    }
  }

  void _addItineraryDetail(int dateIndex) {
    setState(() {
      itineraryPerDate[dateIndex].add(ItineraryDetail());
    });
  }

  void _removeItineraryDetail(int dateIndex, int detailIndex) {
    setState(() {
      if (itineraryPerDate[dateIndex].length > 1) {
        itineraryPerDate[dateIndex].removeAt(detailIndex);
      }
    });
  }

  Future<void> _pickTime(BuildContext context, int dateIndex, int detailIndex) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 0, minute: 0),
    );

    if (selected != null) {
      setState(() {
        itineraryPerDate[dateIndex][detailIndex].time = selected;
      });
    }
  }

  String? _formatTime(TimeOfDay? time) {
    if (time == null) return null;
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 140,
        title: Column(
          children: [
            Align(alignment: Alignment.topLeft, child: ArrowBackButton()),
            Text(widget.trip_name, style: heading),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      widget.location_name,
                      style: location,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const Icon(Icons.location_pin,
                      color: Color.fromRGBO(178, 60, 50, 1), size: 18),
                ],
              ),
            ),
          ],
        ),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dateList.length,
                  itemBuilder: (context, dateIndex) {
                    final date = dateList[dateIndex];
                    final itineraryDetails = itineraryPerDate[dateIndex];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 12.0),
                          child: Text(
                            "Date: ${DateFormat("dd MMM yyyy").format(date)}",
                            style: date_heading,
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: itineraryDetails.length,
                          itemBuilder: (context, detailIndex) {
                            final detail = itineraryDetails[detailIndex];

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2.0, horizontal: 12.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${detailIndex + 1}.",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Color.fromRGBO(
                                                178, 60, 50, 1),
                                            size: 20),
                                        onPressed: () => _removeItineraryDetail(
                                            dateIndex, detailIndex),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          initialValue: detail.name,
                                          decoration: const InputDecoration(
                                            labelText: "Enter Detail Name",
                                          ),
                                          onChanged: (val) =>
                                          detail.name = val,
                                          validator: (val) =>
                                          val == null || val.trim().isEmpty
                                              ? 'Required'
                                              : null,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      SizedBox(
                                        child: GestureDetector(
                                          onTap: () => _pickTime(context, dateIndex, detailIndex),
                                          child: AbsorbPointer(
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                labelText: 'Time',
                                              ),
                                              validator: (_) => detail.time == null
                                                  ? 'Required'
                                                  : null,
                                              controller: TextEditingController(
                                                text: _formatTime(detail.time) ?? '',
                                              ),
                                            ),
                                          ),
                                        ),
                                        width: 120,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    initialValue: detail.note,
                                    minLines: 2,
                                    maxLines: 4,
                                    decoration: const InputDecoration(
                                      labelText: "Custom Note",
                                    ),
                                    onChanged: (val) => detail.note = val,
                                    validator: (val) => val == null || val.trim().isEmpty
                                        ? 'Required'
                                        : null,
                                  ),
                                  SizedBox(height: 5,),
                                ],
                              ),
                            );
                          },
                        ),
                        GestureDetector(
                          onTap: () => _addItineraryDetail(dateIndex),
                          child: Container(
                            alignment: Alignment.center,
                            height: 40,
                            child: Icon(Icons.add,
                                color: Color.fromRGBO(0, 151, 178, 1)),
                          ),
                        ),
                        const Divider(thickness: 2),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                ),
                SaveNextButton(
                  onPress: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddThingsToCarry(
                            trip_name: widget.trip_name,
                            location_name: widget.location_name,
                            trip_type: widget.trip_type,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please complete all fields."),
                          backgroundColor: Colors.redAccent,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  buttonLabel: Text("Next", style: save_next_button),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
