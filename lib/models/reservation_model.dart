import 'package:car_okay/models/cars_model.dart';
import 'package:car_okay/models/rate_model.dart';
import 'package:car_okay/models/services_model.dart';

class ReservationModel {
  final String id;
  final String storeId;
  final String userId;
  final String status;
  final int storeSlot;
  final String date;
  final int timeSlot;
  final int duration;
  final List<String> servicesList;
  final List<ServicesModel> servicesDetailsList;
  final int fee;
  final String carId;
  final String carType;
  final String? photoURL;
  final String? displayName;
  final String bookingId;
  final bool isRated;
  final RateModel rate;
  final CarModel? car;
  final DateTime? dateTime;

  const ReservationModel({
    this.id = "",
    required this.storeId,
    required this.userId,
    required this.status,
    required this.storeSlot,
    required this.date,
    required this.timeSlot,
    required this.duration,
    required this.servicesList,
    this.servicesDetailsList = const [],
    required this.fee,
    required this.carId,
    required this.carType,
    this.photoURL,
    this.displayName,
    required this.bookingId,
    this.isRated = false,
    this.rate = const RateModel(),
    this.car,
    this.dateTime,
  });

  ReservationModel copyWith({
    List<ServicesModel>? servicesDetailsList,
    String? displayName,
    String? status,
    bool? isRated,
    RateModel? rate,
    CarModel? car,
    DateTime? dateTime,
  }) {
    return ReservationModel(
      id: id,
      storeId: storeId,
      userId: userId,
      status: status ?? this.status,
      storeSlot: storeSlot,
      date: date,
      timeSlot: timeSlot,
      duration: duration,
      servicesList: servicesList,
      servicesDetailsList: servicesDetailsList ?? this.servicesDetailsList,
      fee: fee,
      carId: carId,
      carType: carType,
      photoURL: photoURL,
      displayName: displayName ?? this.displayName,
      bookingId: bookingId,
      isRated: isRated ?? this.isRated,
      rate: rate ?? this.rate,
      car: car ?? this.car,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  ReservationModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String? ?? "",
        storeId = json['store_id'] as String,
        userId = json['user_id'] as String,
        status = json['status'] as String,
        timeSlot = json['time_slot'] as int,
        duration = json['duration'] as int,
        date = json['date'] as String,
        storeSlot = json['store_slot'] as int,
        servicesList = (json['service_list'] as List<dynamic>)
            .map((e) => e.toString())
            .toList(),
        servicesDetailsList = const [],
        fee = json['fee'] as int,
        carId = json['car_id'] as String,
        carType = json['car_type'] as String,
        photoURL = json['photoURL'] as String?,
        displayName = json['displayName'] as String?,
        bookingId = json['booking_id'] as String,
        rate = RateModel.fromJson(json['rate']),
        isRated = json['is_rated'] as bool,
        car = null,
        dateTime = DateTime.parse(json['date']);

  Map<String, dynamic> toJson() {
    return {
      "store_id": storeId,
      "user_id": userId,
      "status": status,
      "time_slot": timeSlot,
      "duration": duration,
      "date": date,
      "store_slot": storeSlot,
      "service_list": servicesList,
      "fee": fee,
      "car_id": carId,
      "car_type": carType,
      "photoURL": photoURL,
      "booking_id": bookingId,
      "rate": rate.toJson(),
      'is_rated': isRated,
    };
  }
}
