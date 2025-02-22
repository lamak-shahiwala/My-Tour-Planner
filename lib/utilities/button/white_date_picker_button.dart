import 'package:flutter/material.dart';

class WhiteDatePicker_button extends StatelessWidget {
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

  const WhiteDatePicker_button({
    super.key,
    this.height = 48.0,
    this.width = 128.0,
    this.horizontalMargin = 5.0,
    this.verticalMargin = 5.0,
    this.verticalPadding = 10,
    this.horizontalPadding = 10,
    this.elevationValue = 0,
    this.backgroundColor = const Color.fromRGBO(254, 254, 254, 1),
    this.highlightColor = const Color.fromRGBO(254, 254, 254, 1),
    this.splashColor = const Color.fromRGBO(254, 254, 254, 1),
    this.circularBorderRadius = 5,
    this.borderWidth = 1.2,
    this.borderColor = const Color(0xFFD8DDE3),
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
