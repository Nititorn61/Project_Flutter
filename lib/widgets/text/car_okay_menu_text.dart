import 'package:car_okay/widgets/text/car_okay_text.dart';
import 'package:flutter/material.dart';

class COMenuText extends StatelessWidget {
  final String heading;
  final String content;

  const COMenuText({super.key, required this.heading, required this.content});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        COText("$heading : ", bold: true),
        COText(content),
      ],
    );
  }
}
