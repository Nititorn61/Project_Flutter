import 'package:car_okay/widgets/text/car_okay_text.dart';
import 'package:flutter/material.dart';

class COSnackBar {
  static void show(
    BuildContext context, {
    required String title,
    Color messageColor = Colors.white,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: COText(title, color: messageColor),
      ),
    );
  }
}
