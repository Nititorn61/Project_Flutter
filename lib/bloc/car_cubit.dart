import 'dart:io';

import 'package:car_okay/helper/firebase/firebase.dart';
import 'package:car_okay/helper/snackbar/car_okay_snack_bar.dart';
import 'package:car_okay/models/cars_model.dart';
import 'package:car_okay/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarCubit extends Cubit<List<CarModel>> {
  CarCubit() : super(const []);

  Future<void> removeCar(
    BuildContext context, {
    required CarModel car,
    required String userUid,
  }) async {
    try {
      await fireBaseRemoveCar(context, car: car);
      if (context.mounted) {
        await getCarsByUserId(context, userId: userUid);
      }
    } catch (_) {
      if (context.mounted) {
        COSnackBar.show(context, title: internalServerErrorMessage);
      }
    }
  }

  Future<void> editCar(
    BuildContext context, {
    required String userId,
    required String id,
    required String carTypesId,
    required String plate,
    File? imageFile,
    Function? callback,
  }) async {
    try {
      await fireBaseEditCar(
        context,
        id: id,
        carTypesId: carTypesId,
        plate: plate,
        imageFile: imageFile,
      );
      if (context.mounted) {
        final success = await getCarsByUserId(context, userId: userId);
        if (success && context.mounted) {
          await getCarsByUserId(context, userId: userId);
          if (context.mounted) {
            COSnackBar.show(context, title: "Edit car success");
            if (callback != null) {
              callback();
            } else {
              Navigator.of(context).pop();
            }
          }
        }
      }
    } catch (_) {
      if (context.mounted) {
        COSnackBar.show(context, title: internalServerErrorMessage);
      }
    }
  }

  Future<bool> getCarsByUserId(
    BuildContext context, {
    required String userId,
  }) async {
    final List<CarModel> carsList = await getCarListForUser(userId);
    if (carsList.isEmpty) {
      return false;
    } else {
      emit(carsList);
    }
    return true;
  }

  Future<CarModel?> getCarsById({required String carId}) async {
    return await firebaseGetCarById(carId: carId);
  }

  Future<void> addCarToUser(
    BuildContext context, {
    required String userId,
    required String carTypeId,
    required String plate,
    File? photo,
    Function? callback,
  }) async {
    final success = await fireBaseAddCarToUser(
      context,
      userId: userId,
      carTypesId: carTypeId,
      plate: plate,
      imageFile: photo,
    );

    if (success && context.mounted) {
      await getCarsByUserId(context, userId: userId);
      if (context.mounted) {
        COSnackBar.show(context, title: "Add car to user success");
        if (callback != null) {
          callback();
        } else {
          Navigator.of(context).pop();
        }
      }
    }
  }
}
