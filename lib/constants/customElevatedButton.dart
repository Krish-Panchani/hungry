import 'package:flutter/material.dart';
import 'package:hunger/constants.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final TextStyle textStyle;
  final Color backgroundColor;
  final Color borderColor;

  const CustomElevatedButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.textStyle = const TextStyle(
      color: kPrimaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 15,
    ),
    this.backgroundColor = Colors.white,
    this.borderColor = kPrimaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderColor, width: 2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
      ),
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }
}
