import 'dart:io';

import 'package:car_okay/bloc/auth_cubit.dart';
import 'package:car_okay/helper/bottomSheet/car_okay_bottom_sheet.dart';
import 'package:car_okay/helper/snackbar/car_okay_snack_bar.dart';
import 'package:car_okay/utils/constants.dart';
import 'package:car_okay/utils/image_compress.dart';
import 'package:car_okay/widgets/button/car_okay_elevated_button.dart';
import 'package:car_okay/widgets/button/car_okay_image_button.dart';
import 'package:car_okay/widgets/padding/car_okay_padding.dart';
import 'package:car_okay/widgets/text/car_okay_text.dart';
import 'package:car_okay/widgets/textfield/car_okay_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late AuthCubit _authCubit;

  File? imageFile;
  final ImagePicker picker = ImagePicker();

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  // TextEditingController email = TextEditingController();

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
  void initState() {
    _authCubit = context.read<AuthCubit>();
    final user = _authCubit.state!;
    firstName.text = user.firstName;
    lastName.text = user.lastName;
    phoneNumber.text = user.phoneNumber;
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    phoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: padding,
        child: Wrap(
          alignment: WrapAlignment.center,
          runSpacing: defaultPadding * 2,
          children: [
            COImageButton(
              onTap: () => _buildBottomSheet(context),
              photoURL: _authCubit.state!.photoURL,
              imageFile: imageFile,
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
              maxLength: 10,
            ),
            // COTextField(
            //   label: "Email",
            //   hintText: "Email",
            //   controller: email,
            // ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: double.maxFinite,
        padding: padding,
        child: COElevatedButton(
          onPressed: () => _authCubit.updateUser(
            context,
            id: _authCubit.getUserId(),
            // email: email.text,
            firstName: firstName.text,
            lastName: lastName.text,
            phoneNumber: phoneNumber.text,
            imageFile: imageFile,
          ),
          child: const COText(
            "บันทึกข้อมูล",
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> _buildBottomSheet(BuildContext context) async {
    return COBottomSheet.bottomSheet(
      context,
      [
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
      ],
    );
  }
}
