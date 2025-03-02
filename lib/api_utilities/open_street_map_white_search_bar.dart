import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class OpenStreetMapWhiteSearchBar extends StatefulWidget {
  final String hintText;
  final double topPadding;
  final double bottomPadding;
  final TextEditingController controller;

  OpenStreetMapWhiteSearchBar({super.key,
    this.topPadding = 0,
    this.bottomPadding = 0,
    required this.hintText,
    required this.controller,
  });
  @override
  _OpenStreetMapWhiteSearchBarState createState() => _OpenStreetMapWhiteSearchBarState();
}

class _OpenStreetMapWhiteSearchBarState extends State<OpenStreetMapWhiteSearchBar> {
  List<String> _suggestions = [];
  Timer? _debounce;

  // Function to fetch location suggestions
  void _getSuggestions(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        setState(() {
          _suggestions.clear();
        });
        return;
      }

      String url = "https://nominatim.openstreetmap.org/search?format=json&q=$query";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<String> places = data.map<String>((place) => place["display_name"]).toList();

        setState(() {
          _suggestions = places;
        });
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchSubmitted(String query) {
    setState(() {
      _suggestions.clear(); // Close suggestion list
    });
  }

  @override
  Widget build(BuildContext context) {
    const textFieldStyle = TextStyle(
      color: Color(0xFF666666), //Color(0xFF000000),
      fontSize: 20,
      fontFamily: "Sofia_Sans",
      fontWeight: FontWeight.w400,
    );
    const textField_placeholder = TextStyle(
      color: Color(0xFF666666),
      fontFamily: "Sofia_Sans",
      fontWeight: FontWeight.w400,
      fontSize: 20,
    );
    return Column(
      children: [
        TextField(
          controller: widget.controller,
          style: textFieldStyle,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: textField_placeholder,
            filled: true,
            fillColor: Color.fromRGBO(255, 255, 255, 1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                color: Color(0xFFD8DDE3),
                width: 1.2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                color: Color(0xFFD8DDE3),
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                color: Color(0xFFD8DDE3),
                width: 1.2,
              ),
            ),
            suffixIcon: Icon(Icons.location_pin, color: Color(0xFF0097B2),),
          ),
          onSubmitted: _onSearchSubmitted,
          onChanged: _getSuggestions,
        ),
        if (_suggestions.isNotEmpty) // Show only if suggestions exist
          SizedBox(
            height: 200,
            width: double.infinity,
            child: ListView.builder(
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_suggestions[index]),
                  onTap: () {
                    widget.controller.text = _suggestions[index];
                    setState(() {
                      _suggestions.clear(); // Close suggestion list
                    });
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
