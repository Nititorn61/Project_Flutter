import 'package:car_okay/bloc/auth_cubit.dart';
import 'package:car_okay/layout/car_okay_card_layout.dart';
import 'package:car_okay/utils/constants.dart';
import 'package:car_okay/widgets/button/car_okay_elevated_button.dart';
import 'package:car_okay/widgets/padding/car_okay_floating_button_padding.dart';
import 'package:car_okay/widgets/text/car_okay_text.dart';
import 'package:car_okay/widgets/textfield/car_okay_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  late AuthCubit _authCubit;

  TextEditingController email = TextEditingController();

  @override
  void initState() {
    _authCubit = context.read<AuthCubit>();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: COCardLayout(
        children: [
          Padding(
            padding: padding,
            child: Wrap(
              alignment: WrapAlignment.center,
              runSpacing: defaultPadding * 2,
              children: [
                const SizedBox(
                  width: double.maxFinite,
                  child: COText(
                    "ลืมรหัสผ่าน",
                    textAlign: TextAlign.center,
                    fontSize: 20,
                    bold: true,
                  ),
                ),
                COTextField(
                  label: "Email",
                  hintText: "กรุณากรอก Email ที่ใช้สมัครสมาชิก",
                  controller: email,
                ),
              ],
            ),
          ),
          const COFloatingButtonPadding(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: padding,
        child: SizedBox(
          width: double.maxFinite,
          child: COElevatedButton(
            onPressed: () => _authCubit.forgetPassword(
              context,
              email: email.text,
            ),
            child: const COText(
              "ส่งลิ้งค์รีเซตรหัสผ่าน",
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
