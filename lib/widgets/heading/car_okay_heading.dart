import 'package:car_okay/widgets/text/car_okay_text.dart';
import 'package:flutter/material.dart';

class COHeading extends StatelessWidget {
  final Function() onPressedBack;
  final String title;
  const COHeading({
    super.key,
    required this.onPressedBack,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: onPressedBack,
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: COText(title),
        ),
      ],
    );
  }
}
