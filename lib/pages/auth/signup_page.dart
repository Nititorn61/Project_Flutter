import 'dart:io';

import 'package:car_okay/bloc/auth_cubit.dart';
import 'package:car_okay/helper/bottomSheet/car_okay_bottom_sheet.dart';
import 'package:car_okay/helper/snackbar/car_okay_snack_bar.dart';
import 'package:car_okay/layout/car_okay_card_layout.dart';
import 'package:car_okay/utils/constants.dart';
import 'package:car_okay/utils/image_compress.dart';
import 'package:car_okay/widgets/button/car_okay_elevated_button.dart';
import 'package:car_okay/widgets/button/car_okay_image_button.dart';
import 'package:car_okay/widgets/padding/car_okay_floating_button_padding.dart';
import 'package:car_okay/widgets/padding/car_okay_padding.dart';
import 'package:car_okay/widgets/text/car_okay_text.dart';
import 'package:car_okay/widgets/textfield/car_okay_password_textfield.dart';
import 'package:car_okay/widgets/textfield/car_okay_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late AuthCubit _authCubit;

  final ImagePicker picker = ImagePicker();
  File? imageFile;

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  bool _loading = false;

  bool isPasswordObscure = true;

  void togglePasswordObscure() {
    isPasswordObscure = !isPasswordObscure;
    setState(() {});
  }

  @override
  void initState() {
    _authCubit = context.read<AuthCubit>();
    super.initState();
  }

  Future<void> _onPressed() async {
    if (!_loading) {
      if (email.text.isEmpty) {
        COSnackBar.show(context, title: "Email can't empty");
        return;
      }

      if (password.text.isEmpty) {
        COSnackBar.show(context, title: "Password can't empty");
        return;
      }

      if (firstName.text.isEmpty) {
        COSnackBar.show(context, title: "Firstname can't empty");
        return;
      }

      if (lastName.text.isEmpty) {
        COSnackBar.show(context, title: "LastName can't empty");
        return;
      }

      if (phoneNumber.text.isEmpty) {
        COSnackBar.show(context, title: "Phone Number can't empty");
        return;
      }
      if (username.text.isEmpty) {
        COSnackBar.show(context, title: "Username can't empty");
        return;
      }

      _loading = true;
      setState(() {});
      bool success = await _authCubit.createUser(
        context,
        email: email.text,
        password: password.text,
        firstName: firstName.text,
        lastName: lastName.text,
        phoneNumber: phoneNumber.text,
        username: username.text,
        imageFile: imageFile,
      );

      if (!success) {
        _loading = false;
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    firstName.dispose();
    lastName.dispose();
    phoneNumber.dispose();
    email.dispose();
    super.dispose();
  }

  void onPicker(int index) async {
    XFile? image;
    if (index == 0) {
      final status = await Permission.camera.request();
      if (status.isDenied && mounted) {
        COSnackBar.show(context, title: "Camera permission denied");
      } else {
        image = await picker.pickImage(source: ImageSource.camera);
      }
    } else {
      final status = await Permission.storage.request();
      if (status.isDenied && mounted) {
        COSnackBar.show(context, title: "Gallery permission denied");
      } else {
        image = await picker.pickImage(source: ImageSource.gallery);
      }
    }
    if (image != null) {
      File compress = await COImageCompress(image.path).getCompressFile();
      imageFile = compress;
      setState(() {});
      if (mounted) Navigator.of(context).pop();
    }
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
                    "สมัครสมาชิก",
                    textAlign: TextAlign.center,
                    fontSize: 20,
                    bold: true,
                  ),
                ),
                COImageButton(
                  onTap: () => _buildBottomSheet(context),
                  imageFile: imageFile,
                  isUser: true,
                ),
                COTextField(
                  label: "Username",
                  hintText: "Username",
                  controller: username,
                ),
                COPasswordTextField(
                  label: "Password",
                  hintText: "Password",
                  controller: password,
                  onPressed: togglePasswordObscure,
                  isObscure: isPasswordObscure,
                  isObscureText: true,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      child: COTextField(
                        label: "ชื่อจริง",
                        hintText: "ชื่อจริง",
                        controller: firstName,
                      ),
                    ),
                    const COPadding(width: 1),
                    Flexible(
                      child: COTextField(
                        label: "นามสกุล",
                        hintText: "นามสกุล",
                        controller: lastName,
                      ),
                    ),
                  ],
                ),
                COTextField(
                  label: "เบอร์โทรศัพท์",
                  hintText: "เบอร์โทรศัพท์",
                  controller: phoneNumber,
                  keyboardType: TextInputType.number,
                ),
                COTextField(
                  label: "Email",
                  hintText: "Email",
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
            onPressed: _onPressed,
            child: _loading
                ? const COText(
                    "กำลังสมัครสมาชิก",
                    color: inActiveTextColor,
                  )
                : const COText(
                    "ยืนยันการสมัครสมาชิก",
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _buildBottomSheet(BuildContext context) async {
    return COBottomSheet.bottomSheet(context, [
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
    ]);
  }
}
