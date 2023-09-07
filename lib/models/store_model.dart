import 'package:car_okay/models/rate_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoreModel {
  final String id;
  final String userId;
  final String name;
  final GeoPoint location;
  final String promotion;
  final String open;
  final String close;
  final int slot;
  final String photoURL;
  final String displayPhoto;
  final RateModel rate;
  final int numberOfService;
  final List<String> follows;

  const StoreModel({
    this.id = "",
    this.userId = "",
    this.name = "",
    this.location = const GeoPoint(0, 0),
    this.promotion = "",
    this.open = "",
    this.close = "",
    this.slot = 0,
    this.photoURL = "",
    this.displayPhoto = "",
    this.rate = const RateModel(),
    this.numberOfService = 0,
    this.follows = const [],
  });

  StoreModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        userId = json["user_id"],
        name = json["name"],
        location = json["location"],
        promotion = json["promotion"],
        open = json["open"],
        close = json["close"],
        slot = json["slot"],
        photoURL = json["photoURL"],
        displayPhoto = json["displayPhoto"],
        rate = RateModel.fromJson(json['rate']),
        numberOfService = json['number_of_service'],
        follows = (json['follows'] as List<dynamic>)
            .map((e) => e.toString())
            .toList();

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "name": name,
      "location": location,
      "promotion": promotion,
      "open": open,
      "close": close,
      "slot": slot,
      "photoURL": photoURL,
      "displayPhoto": displayPhoto,
      "rate": rate,
      "number_of_service": numberOfService,
      "follows": follows,
    };
  }
}
