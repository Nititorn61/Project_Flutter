import 'dart:io';

import 'package:flutter/material.dart';

class COImageButton extends StatelessWidget {
  final Function()? onTap;
  final File? imageFile;
  final String? photoURL;
  final bool isUser;
  const COImageButton({
    super.key,
    this.onTap,
    this.imageFile,
    this.photoURL,
    this.isUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: _imageRender(),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                "assets/icon/icon_camera.png",
                width: 28,
                height: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageRender() {
    if (imageFile != null) {
      return Image.file(File(imageFile!.path));
    }
    if (photoURL != null && photoURL!.isNotEmpty) {
      return Image.network(photoURL!);
    }

    if (isUser) {
      return Image.asset("assets/image/profile_placeholder.png");
    } else {
      return Image.asset("assets/image/car_placeholder.png");
    }
  }
}
