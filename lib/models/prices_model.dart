class PricesModel {
  final int price;
  final String carType;

  const PricesModel({
    this.price = 0,
    this.carType = "",
  });

  PricesModel.fromJson(Map<String, Object?> json)
      : this(price: json["price"] as int, carType: json["car_type"] as String);

  Map<String, Object?> toJson() {
    return {
      "price": price,
      "carType": carType,
    };
  }
}
