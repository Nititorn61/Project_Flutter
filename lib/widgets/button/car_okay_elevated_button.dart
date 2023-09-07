import 'package:car_okay/utils/constants.dart';
import 'package:flutter/material.dart';

class COElevatedButton extends StatelessWidget {
  final void Function()? onPressed;
  final Color backgroundColor;
  final Widget child;

  const COElevatedButton(
      {super.key,
      required this.onPressed,
      required this.child,
      this.backgroundColor = buttonPrimaryBackground});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultRadius),
          // side: BorderSide(color: Colors.red),
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
