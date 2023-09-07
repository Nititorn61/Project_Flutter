import 'package:flutter/material.dart';

class COCenterText extends StatelessWidget {
  final String first;
  final String middle;
  final String last;

  const COCenterText({
    super.key,
    required this.first,
    required this.middle,
    required this.last,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: first,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(
            text: " $middle ",
            style: const TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(
            text: last,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
