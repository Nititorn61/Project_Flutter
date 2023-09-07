import 'package:car_okay/bloc/auth_cubit.dart';
import 'package:car_okay/helper/navigator/car_okay_navigator.dart';
import 'package:car_okay/layout/car_okay_card_layout.dart';
import 'package:car_okay/pages/auth/forget_password_page.dart';
import 'package:car_okay/pages/auth/signup_page.dart';
import 'package:car_okay/utils/constants.dart';
import 'package:car_okay/widgets/button/car_okay_elevated_button.dart';
import 'package:car_okay/widgets/button/car_okay_text_button.dart';
import 'package:car_okay/widgets/padding/car_okay_padding.dart';
import 'package:car_okay/widgets/text/car_okay_text.dart';
import 'package:car_okay/widgets/textfield/car_okay_password_textfield.dart';
import 'package:car_okay/widgets/textfield/car_okay_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late AuthCubit _authCubit;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isPasswordObscure = true;

  void togglePasswordObscure() {
    isPasswordObscure = !isPasswordObscure;
    setState(() {});
  }

  @override
  void initState() {
    _authCubit = context.read<AuthCubit>();
    _init();
    super.initState();
  }

  Future<void> _init() async {
    // const _storage = FlutterSecureStorage();
    // _storage.deleteAll();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void onPressedSignUp() {
    CONavigator.push(context, const SignUpPage());
  }

  void onPressedForgetPassword() {
    CONavigator.push(context, const ForgetPasswordPage());
  }

  @override
  Widget build(BuildContext context) {
    return COCardLayout(
      isShowBack: false,
      children: [
        Padding(
          padding: padding,
          child: Wrap(
            alignment: WrapAlignment.center,
            runSpacing: defaultPadding,
            children: [
              COTextField(
                label: "Email หรือ Username",
                hintText: "Email หรือ Username",
                controller: email,
              ),
              const COPadding(height: 0.5),
              COPasswordTextField(
                label: "Password",
                hintText: "Password",
                controller: password,
                onPressed: togglePasswordObscure,
                isObscure: isPasswordObscure,
                isObscureText: true,
              ),
              COTextButton(
                onPressed: onPressedForgetPassword,
                child: const COText(
                  "ลืมรหัสผ่าน ?",
                  color: inActiveTextColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 120),
        Padding(
          padding: padding,
          child: Wrap(
            alignment: WrapAlignment.center,
            runSpacing: defaultPadding,
            children: [
              SizedBox(
                width: double.maxFinite,
                child: COElevatedButton(
                  onPressed: () => _authCubit.emailSignIn(
                    context,
                    emailOrUsername: email.text,
                    password: password.text,
                  ),
                  child: const COText(
                    "เข้าสู่ระบบ",
                    color: Colors.white,
                  ),
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      endIndent: defaultPadding,
                    ),
                  ),
                  COText("or"),
                  Expanded(
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      indent: defaultPadding,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.maxFinite,
                child: COElevatedButton(
                  backgroundColor: buttonSecondaryBackground,
                  onPressed: () => _authCubit.googleSignIn(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const COText(
                        "เข้าสู่ระบบด้วย Google",
                      ),
                      const COPadding(width: 1),
                      Image.asset(
                        "assets/logo/google.png",
                        width: 25,
                        height: 25,
                      ),
                    ],
                  ),
                ),
              ),
              COTextButton(
                onPressed: onPressedSignUp,
                child: const COText(
                  "สมัครสมาชิก",
                  color: Color.fromRGBO(230, 123, 59, 1),
                  fontSize: 14,
                  bold: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
