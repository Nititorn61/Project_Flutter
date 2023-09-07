import 'package:car_okay/utils/constants.dart';
import 'package:car_okay/widgets/padding/car_okay_padding.dart';
import 'package:car_okay/widgets/text/car_okay_text.dart';
import 'package:flutter/material.dart';

class COPasswordTextField extends StatelessWidget {
  final String? label;
  final void Function()? onPressed;
  final bool isObscure;
  final TextEditingController? controller;
  final String? hintText;
  final bool isObscureText;
  final bool isHaveClearText;
  final Color backgroundColor;
  final void Function(String)? onChanged;
  final void Function()? onPressedClear;

  const COPasswordTextField({
    super.key,
    this.onPressed,
    required this.label,
    this.isObscure = false,
    this.isObscureText = false,
    this.controller,
    this.hintText,
    this.backgroundColor = inputPrimaryBackground,
    this.onChanged,
    this.isHaveClearText = false,
    this.onPressedClear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label != null ? COText(label ?? "", bold: true) : const SizedBox(),
        label != null ? const COPadding(height: 1) : const SizedBox(),
        TextField(
          decoration: InputDecoration(
            isDense: true,
            suffixIcon: isHaveClearText
                ? controller!.text.isNotEmpty
                    ? IconButton(
                        onPressed: onPressedClear,
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.close),
                      )
                    : null
                : isObscureText
                    ? IconButton(
                        onPressed: onPressed,
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                      )
                    : null,
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: inputPrimaryBorderColor),
              borderRadius: BorderRadius.all(
                Radius.circular(defaultRadius),
              ),
            ),
            filled: true,
            fillColor: inputPrimaryBackground,
            hintText: hintText,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: defaultPadding,
            ),
          ),
          controller: controller,
          obscureText: isObscure,
          onChanged: onChanged,
          onTap: isObscureText ? null : onPressed,
        ),
      ],
    );
  }
}
