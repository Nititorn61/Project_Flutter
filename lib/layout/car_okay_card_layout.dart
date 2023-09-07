import 'package:car_okay/utils/constants.dart';
import 'package:car_okay/widgets/button/car_okay_text_button.dart';
import 'package:flutter/material.dart';

class COCardLayout extends StatelessWidget {
  final List<Widget> children;
  final bool isShowBack;
  final Function()? onPressedBack;
  const COCardLayout({
    super.key,
    required this.children,
    this.isShowBack = true,
    this.onPressedBack,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: Colors.amber,
        child: Stack(
          children: [
            Container(
              color: appImageBackground,
              width: double.maxFinite,
              height: 400,
              child: Image.asset(
                "assets/image/app_background.png",
                fit: BoxFit.fitWidth,
              ),
            ),
            Visibility(
              visible: isShowBack,
              child: Positioned(
                top: 50,
                child: COTextButton(
                  onPressed: onPressedBack ?? () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: appBodyHeight,
                decoration: const BoxDecoration(
                  color: appPrimaryBackground,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(defaultBorderRadius),
                    topLeft: Radius.circular(defaultBorderRadius),
                  ),
                ),
                child: SizedBox(
                  height: appBodyHeight,
                  width: double.maxFinite,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        ...children,
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
