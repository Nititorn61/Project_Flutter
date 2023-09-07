class CarModel {
  final String id;
  final String userId;
  final String carTypesId;
  final String plate;
  final String? photoURL;

  const CarModel({
    this.id = "",
    this.userId = "",
    this.carTypesId = "",
    this.plate = "",
    this.photoURL,
  });

  CarModel.fromJson(Map<String, Object?> json)
      : this(
            id: json["id"] as String,
            userId: json["user_id"] as String,
            carTypesId: json["car_types_id"] as String,
            plate: json["plate"] as String,
            photoURL: json["photoURL"] as String? ?? "");

  Map<String, Object?> toJson() {
    return {
      "user_id": userId,
      "car_types_id": carTypesId,
      "plate": plate,
      "photoURL": photoURL,
    };
  }
}
