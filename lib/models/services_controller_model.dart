import 'package:flutter/material.dart';

class ServiceControllerModel {
  final String label;
  final bool checked;
  final TextEditingController controller;

  const ServiceControllerModel({
    required this.controller,
    required this.checked,
    required this.label,
  });

  ServiceControllerModel copyWith({
    bool? checked,
  }) {
    return ServiceControllerModel(
      checked: checked ?? this.checked,
      controller: controller,
      label: label,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "car_type": label,
      "price": int.parse(controller.text),
    };
  }
}
