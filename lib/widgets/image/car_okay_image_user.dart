import 'package:flutter/material.dart';

class COImageUser extends StatelessWidget {
  final String? photoURL;
  final double size;

  const COImageUser(this.photoURL, {super.key, this.size = 80});

  Widget _imageBuilder() {
    if (photoURL != null && photoURL!.isNotEmpty) {
      return Image.network(
        photoURL!,
        fit: BoxFit.cover,
      );
    }
    return Image.asset(
      "assets/image/profile_placeholder.png",
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox.fromSize(
        size: Size.fromRadius(size), // Image radius
        child: _imageBuilder(),
      ),
    );
  }
}
