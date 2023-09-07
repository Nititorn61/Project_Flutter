import 'package:car_okay/models/car_types_model.dart';

class CarWithTypeModel {
  final String id;
  final String userUid;
  final String carTypesUid;
  final String plate;
  final String? photoURL;
  final CarTypes carTypes;

  const CarWithTypeModel({
    this.id = "",
    this.userUid = "",
    this.carTypesUid = "",
    this.plate = "",
    this.photoURL,
    required this.carTypes,
  });
}
