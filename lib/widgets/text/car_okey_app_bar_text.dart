import 'package:flutter/material.dart';

class COAppBarText extends StatelessWidget {
  final String data;
  final bool bold;
  final double fontSize;
  final Color color;
  final TextAlign textAlign;
  const COAppBarText(
    this.data, {
    super.key,
    this.fontSize = 16,
    this.bold = true,
    this.color = Colors.white,
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
