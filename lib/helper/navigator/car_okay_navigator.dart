import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class CONavigator {
  static push(BuildContext context, Widget page) {
    return Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child: page,
      ),
    );
  }

  static pushReplacement(BuildContext context, Widget page) {
    return Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child: page,
      ),
    );
  }
}
