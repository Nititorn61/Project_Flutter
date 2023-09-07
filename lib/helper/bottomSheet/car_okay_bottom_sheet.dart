import 'package:car_okay/utils/constants.dart';
import 'package:car_okay/widgets/button/car_okay_elevated_button.dart';
import 'package:car_okay/widgets/padding/car_okay_padding.dart';
import 'package:car_okay/widgets/text/car_okay_text.dart';
import 'package:flutter/material.dart';

class COBottomSheet {
  static Future<void> bottomSheet(BuildContext context, List<Widget> children) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: 270,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(defaultBorderRadius),
                topRight: Radius.circular(defaultBorderRadius),
              )),
          child: Padding(
            padding: padding,
            child: Center(
              child: Wrap(
                runSpacing: defaultPadding,
                children: [
                  const COText(
                    'แนบไฟล์รูปภาพ',
                    bold: true,
                  ),
                  ...children,
                  const COPadding(height: 2),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<void> plain(
      BuildContext context, Function(int) onPicker) async {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: 270,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(defaultBorderRadius),
                topRight: Radius.circular(defaultBorderRadius),
              )),
          child: Padding(
            padding: padding,
            child: Center(
              child: Wrap(
                runSpacing: defaultPadding,
                children: [
                  const COText(
                    'แนบไฟล์รูปภาพ',
                    bold: true,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: COElevatedButton(
                      onPressed: () => onPicker(0),
                      child: const COText(
                        "ถ่ายรูป",
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: COElevatedButton(
                      onPressed: () => onPicker(1),
                      child: const COText(
                        "UPLOAD",
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: COElevatedButton(
                      backgroundColor: buttonSecondaryBackground,
                      onPressed: () => Navigator.pop(context),
                      child: const COText("Cancel"),
                    ),
                  ),
                  const COPadding(height: 2),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
