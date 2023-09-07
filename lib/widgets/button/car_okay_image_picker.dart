import 'dart:io';

import 'package:car_okay/utils/constants.dart';
import 'package:car_okay/widgets/text/car_okay_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class COImagePicker extends StatelessWidget {
  final Function()? onTap;
  final File? imageFile;
  final String? photoURL;
  const COImagePicker({
    super.key,
    this.onTap,
    this.imageFile,
    this.photoURL,
  });

  @override
  Widget build(BuildContext context) {
    if (imageFile != null) {
      return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(defaultRadius)),
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: double.maxFinite,
            // clipBehavior: Clip.antiAlias,
            child: Image.file(
              File(imageFile!.path),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    if (photoURL != null && photoURL!.isNotEmpty) {
      return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(defaultRadius)),
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: double.maxFinite,
            // clipBehavior: Clip.antiAlias,
            child: Image.network(photoURL!, fit: BoxFit.cover),
          ),
        ),
      );
    }

    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(defaultRadius),
      padding: const EdgeInsets.all(6),
      color: buttonPrimaryBackground,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(defaultRadius)),
        child: InkWell(
          onTap: onTap,
          child: const SizedBox(
            width: double.maxFinite,
            height: 100,
            // clipBehavior: Clip.antiAlias,
            child: Center(
                child: COText(
              "เลือกไฟล์",
              bold: true,
            )),
          ),
        ),
      ),
    );
  }
}
