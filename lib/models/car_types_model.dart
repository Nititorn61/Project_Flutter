class CarTypes {
  final String id;
  final String brand;
  final String type;
  final String model;

  const CarTypes({
    this.id = "",
    this.brand = "",
    this.type = "",
    this.model = "",
  });

  CarTypes.fromJson(Map<String, Object?> json)
      : this(
          id: json["id"] as String,
          brand: json["brand"] as String? ?? "",
          type: json["type"] as String? ?? "",
          model: json["model"] as String? ?? "",
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      "brand": brand,
      "type": type,
      "model": model,
    };
  }
}
