import 'package:flutter/material.dart';

class TripTemplateView extends StatelessWidget {
  const TripTemplateView(
      {
        super.key,
        required this.title,
        required this.image,
        required this.location
      });

  final String title;
  final String image;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hello!"),),
      body: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Hello!"),
              Text(title),
            ],
          )),
    );
  }
}
