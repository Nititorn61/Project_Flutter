import 'package:car_okay/utils/constants.dart';
import 'package:car_okay/widgets/padding/car_okay_padding.dart';
import 'package:car_okay/widgets/text/car_okay_text.dart';
import 'package:flutter/material.dart';

class COBox extends StatelessWidget {
  final String? label;
  final Widget child;
  const COBox({super.key, this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label != null ? COText(label!, bold: true) : const SizedBox(),
        label != null ? const COPadding(height: 1) : const SizedBox(),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: inputPrimaryBorderColor,
            ),
            borderRadius: BorderRadius.circular(defaultRadius),
          ),
          width: double.maxFinite,
          child: child,
        ),
      ],
    );
  }
}
