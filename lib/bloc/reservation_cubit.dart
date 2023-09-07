import 'dart:io';

import 'package:car_okay/helper/dialog/car_okay_dialog.dart';
import 'package:car_okay/helper/firebase/firebase.dart';
import 'package:car_okay/helper/snackbar/car_okay_snack_bar.dart';
import 'package:car_okay/models/booking_model.dart';
import 'package:car_okay/models/rate_model.dart';
import 'package:car_okay/models/reservation_model.dart';
import 'package:car_okay/utils/constants.dart';
import 'package:car_okay/utils/options_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReservationCubit extends Cubit<List<ReservationModel>> {
  ReservationCubit() : super(const []);

  void clear() {
    emit([]);
  }

  Future<List<ReservationModel>> getDone(
    BuildContext context, {
    required String storeId,
  }) async {
    return await firebaseGetDoneReservation(context, storeId: storeId);
  }

  Future<void> updateReservationRating(
    BuildContext context, {
    required RateModel rate,
    required ReservationModel model,
  }) async {
    return await firebaseUpdateReservationRating(
      context,
      rate: rate,
      model: model,
    );
  }

  Future<BookingModel> getBooking(
    BuildContext context, {
    required String storeId,
    required String date,
    required int slot,
  }) async {
    return await firebaseGetBooking(
      context,
      storeId: storeId,
      date: date,
      slot: slot,
    );
  }

  void updateReservationDetails(List<ReservationModel> list) {
    emit(list);
  }

  Future<List<ReservationModel>> getListReservationInStore(
    BuildContext context, {
    required String storeId,
  }) async {
    return await firebaseGetListReservation(context, storeId: storeId);
  }

  Future<List<ReservationModel>> getReservation(
    BuildContext context, {
    required String userId,
  }) async {
    return await firebaseGetReservation(context, userId: userId);
  }

  Future<void> changeStatusReservation(
    BuildContext context, {
    required ReservationModel model,
    required String status,
  }) async {
    if (!reservationStatusList.contains(status)) {
      COSnackBar.show(context, title: "ไม่มีสถานะนี้ในระบบ");
      return;
    }

    bool success = await firebaseUpdateStatusReservation(
      context,
      reservationId: model.id,
      status: status,
    );

    if ((status == reservationStatusList.last || status == "เสร็จสิ้น") &&
        context.mounted) {
      List<int> removed = [];
      for (int i = 0; i < model.duration; i++) {
        removed.add(model.timeSlot + i);
      }
      await firebaseRemoveReservedTime(context,
          bookingId: model.bookingId, removed: removed);
    }

    if (success && context.mounted) {
      var update = [...state];
      int updateIndex = update.indexWhere((resv) => model.id == resv.id);
      update[updateIndex] = update[updateIndex].copyWith(status: status);
      emit(update);
    }
  }

  Future<bool> updateStatusReservation(
    BuildContext context, {
    required ReservationModel reservationModel,
    required String status,
    bool isPopContext = true,
  }) async {
    if (!reservationStatusList.contains(status)) {
      COSnackBar.show(context, title: "ไม่มีสถานะนี้ในระบบ");
      return false;
    }

    bool success = await firebaseUpdateStatusReservation(
      context,
      reservationId: reservationModel.id,
      status: status,
    );

    if (status == "จองคิวสำเร็จ" && context.mounted) {
      List<int> added = [];
      for (int i = 0; i < reservationModel.duration; i++) {
        added.add(reservationModel.timeSlot + i);
      }
      await firebaseRemoveOtherBooking(
        context,
        resvId: reservationModel.id,
        bookingId: reservationModel.bookingId,
        storeId: reservationModel.storeId,
        date: reservationModel.date,
        slot: reservationModel.storeSlot,
        reserved: added,
      );
    }

    if ((status == reservationStatusList.last || status == "เสร็จสิ้น") &&
        context.mounted) {
      List<int> removed = [];
      for (int i = 0; i < reservationModel.duration; i++) {
        removed.add(reservationModel.timeSlot + i);
      }
      await firebaseRemoveReservedTime(context,
          bookingId: reservationModel.bookingId, removed: removed);
    }

    if (success && context.mounted) {
      if (isPopContext) Navigator.of(context).pop();
      return true;
    }

    return false;
  }

  Future<bool> addReservation(
    BuildContext context,
    final void Function() onSuccess, {
    required String storeId,
    required String userId,
    required String status,
    required int storeSlot,
    required String date,
    required int timeSlot,
    required int duration,
    required List<String> servicesList,
    required int fee,
    required String carId,
    required String carType,
    required File imageFile,
    required String bookingId,
    required List<int> reserved,
  }) async {
    try {
      Future.wait([
        firebaseAddReservation(
          context,
          storeId: storeId,
          userId: userId,
          status: status,
          storeSlot: storeSlot,
          date: date,
          timeSlot: timeSlot,
          duration: duration,
          servicesList: servicesList,
          fee: fee,
          carId: carId,
          carType: carType,
          imageFile: imageFile,
          bookingId: bookingId,
        ),
        firebaseUpdateBooking(
          context,
          id: bookingId,
          storeId: storeId,
          date: date,
          slot: storeSlot,
          reserved: reserved,
        ),
      ]).then((_) {
        onSuccess();
        CODialog.progress(context);
      });
    } catch (_) {
      COSnackBar.show(context, title: internalServerErrorMessage);
    }
    return false;
  }
}
