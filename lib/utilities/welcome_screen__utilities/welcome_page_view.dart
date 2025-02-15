import 'package:flutter/material.dart';
import 'package:my_tour_planner/utilities/welcome_screen__utilities/dot_animation.dart';
import 'package:my_tour_planner/utilities/text/text_styles.dart';


class page_view_for_features extends StatelessWidget {
  const page_view_for_features({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
     child: PageView(children: const [
       welcome1(),
       welcome2(),
       welcome3(),
       welcome4(),
     ],),
    );
  }
}


class welcome1 extends StatelessWidget {
  const welcome1({super.key});

  final String para1 = "Lorem ipsum dolor sit amet"
      ", consectetur adipiscing elit. L"
      "orem ipsum dolor sit amet, consecte"
      "tur adipiscing elitcbkdc.";
  final String sub_heading1 = "Do you want to Travel?";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Image.asset(
          'assets/images/welcome1_img.png',
          width: 300,
          height: 300,
        ),
        const SizedBox(
          height: 60,
        ),
        Text(
          sub_heading1,
          style: sub_heading,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          para1, textAlign: TextAlign.justify,
          style: lightGrey_paragraph_text,
        ),
        const Spacer(),
        const dot_1(),
      ],),
    );
  }
}

class welcome2 extends StatelessWidget {
  const welcome2({super.key});

  final String para1 = "Lorem ipsum dolor sit amet"
      ", consectetur adipiscing elit. L"
      "orem ipsum dolor sit amet, consecte"
      "tur adipiscing elitcbkdc.";
  final String sub_heading1 = "All your trips in a single app";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Image.asset(
          'assets/images/welcome2_img.png',
          width: 299,
          height: 299,
        ),
        const SizedBox(
          height: 60,
        ),
        Text(
          sub_heading1,
          style: sub_heading,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          para1, textAlign: TextAlign.justify,
          style: lightGrey_paragraph_text,
        ),
        const Spacer(),
        const dot_2(),
      ],),
    );
  }
}


class welcome3 extends StatelessWidget {
  const welcome3({super.key});

  final String para1 = "Lorem ipsum dolor sit amet"
      ", consectetur adipiscing elit. L"
      "orem ipsum dolor sit amet, consecte"
      "tur adipiscing elitcbkdc.";
  final String sub_heading1 = "Your destiny, our goal";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Image.asset(
          'assets/images/welcome3_img.png',
          width: 299,
          height: 257,
        ),
        const SizedBox(
          height: 60,
        ),
        Text(
          sub_heading1,
          style: sub_heading,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          para1, textAlign: TextAlign.justify,
          style: lightGrey_paragraph_text,
        ),
        const Spacer(),
        const dot_3(),
      ],),
    );
  }
}


class welcome4 extends StatelessWidget {
  const welcome4({super.key});

  final String para1 = "Lorem ipsum dolor sit amet"
      ", consectetur adipiscing elit. L"
      "orem ipsum dolor sit amet, consecte"
      "tur adipiscing elitcbkdc.";
  final String sub_heading1 = "What are waiting for?";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Image.asset(
          'assets/images/welcome4_img.png',
          width: 236,
          height: 265,
        ),
        const SizedBox(
          height: 60,
        ),
        Text(
          sub_heading1,
          style: sub_heading,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          para1, textAlign: TextAlign.justify,
          style: lightGrey_paragraph_text,
        ),
        const Spacer(),
        const dot_4(),
      ],),
    );
  }
}