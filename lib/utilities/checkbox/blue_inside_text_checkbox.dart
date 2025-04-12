import 'package:flutter/material.dart';

class BlueInsideTextCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final double horizontal_padding;
  final double vertical_padding;
  final double horizontal_margin;
  final double vertical_margin;
  final double height;
  final double width;

  const BlueInsideTextCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.horizontal_padding = 12,
    this.vertical_padding = 10,
    this.horizontal_margin = 5,
    this.vertical_margin = 8,
    this.height = 0,
    this.width = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        constraints: BoxConstraints(
          minHeight: height,
          minWidth: width,
        ),
        margin: EdgeInsets.symmetric(horizontal: horizontal_margin, vertical: vertical_margin),
        padding: EdgeInsets.symmetric(horizontal: horizontal_padding, vertical: vertical_padding),
        decoration: BoxDecoration(
          color: value
              ? const Color.fromRGBO(0, 157, 192, 1)
              : Colors.transparent,
          border: Border.all(
            color: const Color.fromRGBO(211, 211, 211, 1),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: value
                ? const Color.fromRGBO(254, 254, 254, 0.85)
                : const Color.fromRGBO(211, 211, 211, 1),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
