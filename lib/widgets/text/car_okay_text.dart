import 'package:car_okay/utils/constants.dart';
import 'package:flutter/material.dart';

class COText extends StatelessWidget {
  final String data;
  final bool bold;
  final double fontSize;
  final Color color;
  final TextAlign textAlign;
  const COText(
    this.data, {
    super.key,
    this.fontSize = 16,
    this.bold = false,
    this.color = textColor,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
      ),
    );
  }
}
