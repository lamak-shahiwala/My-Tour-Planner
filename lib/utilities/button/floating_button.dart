import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  final EdgeInsets buttonPadding;
  final Color buttonBackgroundColor;
  final String buttonHeroTag;
  final VoidCallback? onPressed;
  final bool isDisabled;

  const FloatingButton({
    super.key,
    required this.buttonPadding,
    required this.buttonBackgroundColor,
    required this.buttonHeroTag,
    this.onPressed,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: buttonPadding,
      child: AbsorbPointer(
        absorbing: isDisabled,
        child: SizedBox(
          height: 60,
          width: 60,
          child: FloatingActionButton(
            heroTag: buttonHeroTag,
            backgroundColor: buttonBackgroundColor,
            elevation: 0,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: isDisabled ? null : onPressed,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(3.14),
              child: Image.asset(
                height: 50,
                width: 50,
                "assets/images/icons/ai-chat-icon.png",
              ),
            ),
          ),
        ),
      ),
    );
  }
}