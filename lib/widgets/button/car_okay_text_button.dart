import 'package:flutter/material.dart';

class COTextButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget child;
  const COTextButton({super.key, required this.child, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onPressed, child: child);
  }
}
