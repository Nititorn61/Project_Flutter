import 'package:car_okay/utils/constants.dart';
import 'package:flutter/material.dart';

class COTextSearchField extends StatelessWidget {
  final void Function()? onPressed;
  final TextEditingController? controller;
  final Color backgroundColor;
  final void Function(String)? onChanged;
  final void Function()? onPressedClear;

  const COTextSearchField({
    super.key,
    this.onPressed,
    this.controller,
    this.backgroundColor = inputPrimaryBackground,
    this.onChanged,
    this.onPressedClear,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        // style: TextStyle(fontSize: ),
        decoration: InputDecoration(
          // isDense: true,
          prefixIcon: const Icon(
            Icons.search,
          ),
          suffixIcon: IconButton(
            onPressed: onPressedClear,
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.close),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: inputPrimaryBorderColor),
            borderRadius: BorderRadius.all(
              Radius.circular(defaultRadius),
            ),
          ),
          filled: true,
          fillColor: inputPrimaryBackground,
          hintText: "Search",
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
          ),
        ),
        controller: controller,
        onChanged: onChanged,
      ),
    );
  }
}
