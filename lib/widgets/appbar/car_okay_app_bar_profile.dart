import 'package:car_okay/utils/constants.dart';
import 'package:car_okay/widgets/text/car_okey_app_bar_text.dart';
import 'package:flutter/material.dart';

class COAppBarProfile extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  const COAppBarProfile({super.key, required this.title, this.onPressed});

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      leading: BackButton(
        color: Colors.white,
        onPressed: onPressed,
      ),
      title: COAppBarText(title),
      backgroundColor: appBarBackgroundColor,
      elevation: 1,
    );
  }
}
