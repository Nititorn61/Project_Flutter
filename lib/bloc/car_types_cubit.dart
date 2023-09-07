import 'dart:convert';

import 'package:car_okay/helper/firebase/firebase.dart';
import 'package:car_okay/models/car_types_model.dart';
import 'package:car_okay/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CarTypesCubit extends Cubit<List<CarTypes>> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  CarTypesCubit() : super(const []);

  CarTypes findCarTypesById(String id) {
    return state.firstWhere((element) => element.id == id);
  }

  CarTypes findCarTypes({
    required String brand,
    required String type,
    required String model,
  }) {
    return state.firstWhere((carType) =>
        carType.brand == brand &&
        carType.type == type &&
        carType.model == model);
  }

  Future<List<CarTypes>> _fetchData() async {
    final List<CarTypes> carTypesList = await firebaseGetCarTypes();
    //Set stale for data 3 days to refetch & set data to localstorage
    await Future.wait([
      _storage.write(
          key: carTypesFetchDateStorageKey,
          value: jsonEncode(
              DateTime.now().add(const Duration(days: 3)).toString())),
      _storage.write(
          key: carTypesStorageKey,
          value: jsonEncode(carTypesList.map((e) => e.toJson()).toList())),
    ]);
    return carTypesList;
  }

  Future<void> getCarTypesFromFirebase() async {
    String? fetchDate = await _storage.read(key: carTypesFetchDateStorageKey);
    if (fetchDate == null) {
      final carTypesList = await _fetchData();
      emit(carTypesList);
      return;
    } else {
      DateTime now = DateTime.now();
      DateTime fetchDateTime = DateTime.parse(jsonDecode(fetchDate));
      //Current time is not reach stale time
      if (now.compareTo(fetchDateTime) < 0) {
        String? raw = await _storage.read(key: carTypesStorageKey);
        //Found car types in localstorage
        if (raw != null) {
          List<CarTypes> carTypesList = (jsonDecode(raw) as List<dynamic>)
              .map((json) => CarTypes.fromJson(json))
              .toList();
          emit(carTypesList);
          return;
        } else {
          final carTypesList = await _fetchData();
          emit(carTypesList);
          return;
        }
      } else {
        //After stale data refetch data to local
        final carTypesList = await _fetchData();
        emit(carTypesList);
        return;
      }
    }
  }
}
