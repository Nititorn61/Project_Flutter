import 'package:flutter/material.dart';

class COFullScreenLayout extends StatelessWidget {
  final Widget child;
  final Widget? bottomNavigationBar;
  final Color color;
  final Widget? heading;

  const COFullScreenLayout({
    super.key,
    required this.child,
    this.bottomNavigationBar,
    this.color = Colors.white70,
    this.heading,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: color,
        child: child,
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
