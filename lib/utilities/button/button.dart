import 'package:flutter/material.dart';

class active_button_blue extends StatelessWidget {

  final double horizontalMargin;
  final double verticalMargin;
  final double horizontalPadding;
  final double verticalPadding;
  final double height;
  final double elevationValue;
  final Color backgroundColor;
  final Color borderColor;
  final Color splashColor;
  final Color highlightColor;
  final double circularBorderRadius;
  final double borderWidth;
  final Widget buttonLabel;
  final void Function()? onPress;

  const active_button_blue({super.key, 
    this.height = 42.0,
    this.horizontalMargin = 5.0,
    this.verticalMargin = 5.0,
    this.verticalPadding = 10,
    this.horizontalPadding = 10,
    this.elevationValue = 0 ,
    this.backgroundColor = const Color.fromRGBO(0, 151, 178, 1),
    this.highlightColor = const Color.fromRGBO(0, 151, 178, 1),
    this.splashColor = const Color.fromRGBO(0, 151, 178, 1),
    this.circularBorderRadius = 5,
    this.borderWidth = 2,
    this.borderColor = const Color.fromRGBO(0, 151, 178, 1),
    required this.onPress,
    required this.buttonLabel,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      margin: EdgeInsets.symmetric(
          horizontal: horizontalMargin, vertical: verticalMargin),
      child: MaterialButton(
        onPressed: onPress,
        color: backgroundColor,
        splashColor: splashColor,
        highlightColor: highlightColor,
        elevation: elevationValue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circularBorderRadius),
          side: BorderSide(color: borderColor, width: borderWidth),
        ),
        padding: EdgeInsets.symmetric(
            vertical: verticalPadding, horizontal: horizontalPadding),
        child: buttonLabel,
      ),
    );
  }
}

class active_button_white extends StatelessWidget {

  final double horizontalMargin;
  final double verticalMargin;
  final double horizontalPadding;
  final double verticalPadding;
  final double height;
  final double elevationValue;
  final Color backgroundColor;
  final Color borderColor;
  final Color splashColor;
  final Color highlightColor;
  final double circularBorderRadius;
  final double borderWidth;
  final Widget buttonLabel;
  final void Function()? onPress;

  const active_button_white({super.key, 
    this.height = 42.0,
    this.horizontalMargin = 5.0,
    this.verticalMargin = 5.0,
    this.verticalPadding = 10,
    this.horizontalPadding = 10,
    this.elevationValue = 0 ,
    this.backgroundColor = const Color.fromRGBO(254, 254, 254, 1),
    this.highlightColor = const Color.fromRGBO(254, 254, 254, 1),
    this.splashColor = const Color.fromRGBO(254, 254, 254, 1),
    this.circularBorderRadius = 5,
    this.borderWidth = 2,
    this.borderColor = const Color.fromRGBO(0, 151, 178, 1),
    required this.onPress,
    required this.buttonLabel,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      margin: EdgeInsets.symmetric(
          horizontal: horizontalMargin, vertical: verticalMargin),
      child: MaterialButton(
        onPressed: onPress,
        color: backgroundColor,
        splashColor: splashColor,
        highlightColor: highlightColor,
        elevation: elevationValue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circularBorderRadius),
          side: BorderSide(color: borderColor, width: borderWidth),
        ),
        padding: EdgeInsets.symmetric(
            vertical: verticalPadding, horizontal: horizontalPadding),
        child: buttonLabel,
      ),
    );
  }
}

class create_generate_button extends StatelessWidget {

  final double horizontalMargin;
  final double verticalMargin;
  final double horizontalPadding;
  final double verticalPadding;
  final double height;
  final double width;
  final double elevationValue;
  final Color backgroundColor;
  final Color borderColor;
  final Color splashColor;
  final Color highlightColor;
  final double circularBorderRadius;
  final double borderWidth;
  final Widget buttonLabel;
  final void Function()? onPress;

  const create_generate_button({super.key,
    this.height = 101.0,
    this.width = 269,
    this.horizontalMargin = 5.0,
    this.verticalMargin = 5.0,
    this.verticalPadding = 10,
    this.horizontalPadding = 10,
    this.elevationValue = 0 ,
    this.backgroundColor = const Color.fromRGBO(0, 151, 178, 1),
    this.highlightColor = const Color.fromRGBO(0, 151, 178, 1),
    this.splashColor = const Color.fromRGBO(0, 151, 178, 1),
    this.circularBorderRadius = 10,
    this.borderWidth = 2,
    this.borderColor = const Color.fromRGBO(254, 254, 254, 1),
    required this.onPress,
    required this.buttonLabel,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.symmetric(
          horizontal: horizontalMargin, vertical: verticalMargin),
      child: MaterialButton(
        onPressed: onPress,
        color: backgroundColor,
        splashColor: splashColor,
        highlightColor: highlightColor,
        elevation: elevationValue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circularBorderRadius),
          side: BorderSide(color: borderColor, width: borderWidth),
        ),
        padding: EdgeInsets.symmetric(
            vertical: verticalPadding, horizontal: horizontalPadding),
        child: buttonLabel,
      ),
    );
  }
}


