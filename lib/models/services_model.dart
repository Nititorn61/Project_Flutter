import 'package:car_okay/models/prices_model.dart';

class ServicesModel {
  final String id;
  final String storeId;
  final String name;
  final int duration;
  final List<PricesModel> prices;
  final bool isDeleted;

  const ServicesModel({
    this.id = "",
    this.storeId = "",
    this.name = "",
    this.duration = 0,
    this.prices = const [],
    this.isDeleted = false,
  });

  ServicesModel.fromJson(Map<String, Object?> json)
      : this(
            id: json["id"] as String? ?? "",
            storeId: json["store_id"] as String? ?? "",
            name: json["name"] as String? ?? "",
            duration: json["duration"] as int,
            prices: (json["prices"] as List<dynamic>)
                .map((e) => PricesModel.fromJson(e))
                .toList(),
            isDeleted: json['is_deleted'] as bool);

  Map<String, Object?> toJson() {
    return {
      "store_id": storeId,
      "name": name,
      "duration": duration,
      "prices": prices.map((e) => e.toJson()),
      'is_deleted': isDeleted,
    };
  }
}
