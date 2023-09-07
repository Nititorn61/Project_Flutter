import 'package:car_okay/utils/constants.dart';
import 'package:car_okay/widgets/padding/car_okay_padding.dart';
import 'package:car_okay/widgets/text/car_okay_text.dart';
import 'package:flutter/material.dart';

class CODropdownButton extends StatefulWidget {
  final String? value;
  final Function(String?)? onChanged;
  final List<String> list;
  final String? hint;
  final String? label;
  final double height;
  const CODropdownButton({
    super.key,
    required this.value,
    required this.list,
    this.label,
    this.onChanged,
    this.hint,
    this.height = 50,
  });

  @override
  State<CODropdownButton> createState() => _CODropdownButtonState();
}

class _CODropdownButtonState extends State<CODropdownButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.label != null
            ? COText(
                widget.label!,
                bold: true,
              )
            : const SizedBox(),
        widget.label != null ? const COPadding(height: 1) : const SizedBox(),
        Container(
          height: widget.height,
          width: double.maxFinite,
          decoration: BoxDecoration(
              border: Border.all(
                color: inputPrimaryBorderColor,
              ),
              borderRadius:
                  const BorderRadius.all(Radius.circular(defaultRadius))),
          padding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: defaultPadding,
          ),
          child: DropdownButton<String>(
            value: widget.value,
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down),
            elevation: 16,
            hint: widget.hint != null ? COText(widget.hint!) : null,
            underline: const SizedBox(),
            onChanged: widget.onChanged,
            items: widget.list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
