import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ThingsToCarryWidget extends StatefulWidget {
  final tripId;

  const ThingsToCarryWidget({super.key, required this.tripId});

  @override
  State<ThingsToCarryWidget> createState() => _ThingsToCarryWidgetState();
}

class _ThingsToCarryWidgetState extends State<ThingsToCarryWidget> {
  final supabase = Supabase.instance.client;

  late Future<List<String>> _carryItemsFuture;

  @override
  void initState() {
    super.initState();
    _carryItemsFuture = _fetchThingsToCarry();
  }

  Future<List<String>> _fetchThingsToCarry() async {
    try {
      final res = await supabase
          .from('things_to_carry')
          .select()
          .eq('trip_id', widget.tripId)
          .maybeSingle();

      print('Things response: $res');

      if (res == null) {
        await supabase.from('things_to_carry').insert({
          'trip_id': widget.tripId,
          'carry_item': jsonEncode([]),
        });
        return [];
      }

      final raw = res['carry_item'];
      return raw != null ? List<String>.from(jsonDecode(raw)) : [];
    } catch (e) {
      print('Error fetching carry items: $e');
      return [];
    }
  }


  Future<void> _addNewItem(String newItem) async {
    try {
      final response = await supabase
          .from('things_to_carry')
          .select()
          .eq('trip_id', widget.tripId)
          .single();

      final currentItems = response['carry_item'] != null
          ? List<String>.from(jsonDecode(response['carry_item']))
          : <String>[];

      currentItems.add(newItem);

      await supabase.from('things_to_carry').update({
        'carry_item': jsonEncode(currentItems),
      }).eq('trip_id', widget.tripId);

      setState(() {
        _carryItemsFuture = Future.value(currentItems);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Item added!")),
      );
    } catch (e) {
      print("Error adding item: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error adding item.")),
      );
    }
  }

  Future<void> _removeItem(int index) async {
    try {
      final response = await supabase
          .from('things_to_carry')
          .select()
          .eq('trip_id', widget.tripId)
          .single();

      final List<String> currentItems = response['carry_item'] != null
          ? List<String>.from(jsonDecode(response['carry_item']))
          : <String>[];

      if (index >= 0 && index < currentItems.length) {
        currentItems.removeAt(index);

        await supabase.from('things_to_carry').update({
          'carry_item': jsonEncode(currentItems),
        }).eq('trip_id', widget.tripId);

        setState(() {
          _carryItemsFuture = Future.value(currentItems);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Item removed!")),
        );
      }
    } catch (e) {
      print("Error removing item: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error removing item.")),
      );
    }
  }

  Future<void> _showAddItemDialog() async {
    String inputText = "";

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Item"),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: "Enter item name"),
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

    if (result != null && result.trim().isNotEmpty) {
      await _addNewItem(result.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _carryItemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Text("Failed to load things to carry.");
        }

        final items = snapshot.data ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Things to Carry:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (items.isEmpty)
              const Text("No items added yet.")
            else
              ...items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Expanded(child: Text("${index + 1}. $item")),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18, color: Colors.red),
                        onPressed: () => _removeItem(index),
                      ),
                    ],
                  ),
                );
              }),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: _showAddItemDialog,
              icon: const Icon(Icons.add),
              label: const Text("Add Item"),
            ),
          ],
        );
      },
    );
  }
}
