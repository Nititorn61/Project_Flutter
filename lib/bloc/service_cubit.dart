import 'package:car_okay/helper/firebase/firebase.dart';
import 'package:car_okay/helper/snackbar/car_okay_snack_bar.dart';
import 'package:car_okay/models/services_controller_model.dart';
import 'package:car_okay/models/services_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceCubit extends Cubit<List<ServicesModel>> {
  ServiceCubit() : super(const []);

  Future<ServicesModel> getServiceById(String serviceId) async {
    return await firebaseGetServiceById(serviceId);
  }

  Future<void> getMyStoreService(
    BuildContext context, {
    required String storeUid,
  }) async {
    List<ServicesModel> models =
        await firebaseGetService(context, storeUid: storeUid);
    emit(models);
  }

  Future<void> addService(
    BuildContext context, {
    required String storeUid,
    required String name,
    required String duration,
    required List<ServiceControllerModel> prices,
  }) async {
    COSnackBar.show(context, title: "กำลังบันทึกข้อมูล");
    await firebaseAddService(
      context,
      storeUid: storeUid,
      name: name,
      duration: int.parse(duration.split(" ").first),
      prices: prices,
    ).then((_) {
      COSnackBar.show(context, title: "บันทึกข้อมูลสำเร็จ");
      getMyStoreService(context, storeUid: storeUid);
      Navigator.of(context).pop();
    });
  }

  Future<void> removeService(
    BuildContext context, {
    required String docId,
    required String storeUid,
  }) async {
    await firebaseRemoveService(context, docId: docId).then(
      (_) {
        getMyStoreService(context, storeUid: storeUid);
      },
    );
  }

  Future<void> editService(
    BuildContext context, {
    required String docId,
    required String storeUid,
    required String name,
    required String duration,
    required List<ServiceControllerModel> prices,
  }) async {
    COSnackBar.show(context, title: "กำลังบันทึกข้อมูล");
    await firebaseEditService(
      context,
      docId: docId,
      storeUid: storeUid,
      name: name,
      duration: int.parse(duration.split(" ").first),
      prices: prices,
    ).then((_) {
      COSnackBar.show(context, title: "บันทึกข้อมูลสำเร็จ");
      getMyStoreService(context, storeUid: storeUid);
      Navigator.of(context).pop();
    });
  }
}
