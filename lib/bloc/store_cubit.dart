import 'dart:io';

import 'package:car_okay/helper/firebase/firebase.dart';
import 'package:car_okay/models/rate_model.dart';
import 'package:car_okay/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StoreCubit extends Cubit<StoreModel> {
  StoreCubit() : super(const StoreModel());

  Future<void> updateFollow(
    BuildContext context, {
    required bool isAdded,
    required String userId,
    required StoreModel store,
  }) async {
    return await firebaseUpdateFollowStore(
      context,
      isAdded: !isAdded,
      store: store,
      userId: userId,
    );
  }

  Future<void> updateRating(
    BuildContext context, {
    required StoreModel model,
    required RateModel rate,
  }) async {
    return await firebaseUpdateRatingStore(context, model: model, rate: rate);
  }

  Future<List<StoreModel>> getStoreList() async {
    return await firebaseGetAllStore();
  }

  Future<StoreModel> getStoreByUid(String storeUid) async {
    return await firebaseGetStoreByUid(storeUid);
  }

  Future<void> getMyStore(
    BuildContext context, {
    required String userId,
  }) async {
    StoreModel? store = await firebaseGetStore(userId);
    if (store != null) {
      emit(store);
    } else {
      emit(const StoreModel());
      // CONavigator(
      //   context,
      //   AddStorePage()
      // );
    }
  }

  Future<void> updateMyStore(
    BuildContext context, {
    required String userId,
    required String name,
    required String promotion,
    required LatLng location,
    required String open,
    required String close,
    required int slot,
    required int numberOfService,
    required List<String> follows,
    RateModel? rate,
    File? storeDisplayImage,
    File? qrImage,
    String? storeDisplayImageUrl,
    String? qrImageUrl,
  }) async {
    bool success = await firebaseUpdateStore(
      context,
      userId: userId,
      name: name,
      promotion: promotion,
      location: location,
      open: open,
      close: close,
      slot: slot,
      numberOfService: numberOfService,
      rate: rate,
      follows: follows,
      storeDisplayImage: storeDisplayImage,
      qrImage: qrImage,
      storeDisplayImageUrl: storeDisplayImageUrl,
      qrImageUrl: qrImageUrl,
    );
    if (context.mounted && success) {
      getMyStore(context, userId: userId);
      Navigator.of(context).pop();
    }
  }
}
