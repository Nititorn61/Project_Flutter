import 'package:car_okay/utils/constants.dart';
import 'package:car_okay/widgets/text/car_okay_text.dart';
import 'package:flutter/material.dart';

class CONavigateButton extends StatelessWidget {
  final void Function()? onPressed;
  final Color backgroundColor;
  final String title;

  const CONavigateButton(
      {super.key,
      required this.onPressed,
      required this.title,
      this.backgroundColor = buttonSecondaryBackground});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultRadius),
          // side: BorderSide(color: Colors.red),
        ),
        elevation: 8,
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: defaultPadding),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            COText(
              title,
              color: buttonPrimaryTextColor,
            ),
            const Icon(
              Icons.keyboard_arrow_right,
              color: buttonPrimaryTextColor,
            ),
          ],
        ),
      ),
    );
  }
}
