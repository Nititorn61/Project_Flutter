import 'package:car_okay/utils/constants.dart';
import 'package:flutter/material.dart';

class COPadding extends StatelessWidget {
  final double width;
  final double height;
  const COPadding({super.key, this.width = 0, this.height = 0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: defaultPadding * width,
      height: defaultPadding * height,
    );
  }
}
