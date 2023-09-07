import 'package:flutter/material.dart';

class COFloatingButtonPadding extends StatelessWidget {
  final bool isHaveBottomnavigator;
  const COFloatingButtonPadding(
      {super.key, this.isHaveBottomnavigator = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isHaveBottomnavigator ? 250 : 80,
    );
  }
}
