import 'package:car_okay/widgets/padding/car_okay_padding.dart';
import 'package:car_okay/widgets/text/car_okay_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CORating extends StatelessWidget {
  final String title;
  final double rate;
  const CORating({super.key, required this.title, required this.rate});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: COText(title, bold: true),
        ),
        const COPadding(height: 1),
        Expanded(
          flex: 3,
          child: RatingBarIndicator(
            rating: rate,
            itemBuilder: (context, index) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: 30,
            unratedColor: Colors.amber.withAlpha(50),
          ),
        )
      ],
    );
  }
}
