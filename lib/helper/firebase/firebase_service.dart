part of 'firebase.dart';

Future<ServicesModel?> firebaseAddService(
  BuildContext context, {
  required String storeUid,
  required String name,
  required int duration,
  required List<ServiceControllerModel> prices,
}) async {
  CollectionReference serviceRef =
      FirebaseFirestore.instance.collection('services');

  var priceJson = [];
  for (var price in prices) {
    if (price.checked) {
      priceJson.add(price.toJson());
    }
  }

  Map<String, dynamic> servicesJson = {
    "store_uid": storeUid,
    "name": name,
    "duration": duration,
    "prices": priceJson,
    "is_deleted": false,
  };

  try {
    await serviceRef.add(servicesJson);
    return ServicesModel.fromJson(servicesJson);
  } on FirebaseException catch (e) {
    if (context.mounted) {
      COSnackBar.show(context, title: e.message ?? internalServerErrorMessage);
    }
  } catch (e) {
    if (context.mounted) {
      COSnackBar.show(context, title: e.toString());
    }
  }

  return null;
}

Future<ServicesModel?> firebaseEditService(
  BuildContext context, {
  required String docId,
  required String storeUid,
  required String name,
  required int duration,
  required List<ServiceControllerModel> prices,
}) async {
  CollectionReference serviceRef =
      FirebaseFirestore.instance.collection('services');

  var priceJson = [];
  for (var price in prices) {
    if (price.checked) {
      priceJson.add(price.toJson());
    }
  }

  Map<String, dynamic> servicesJson = {
    "store_uid": storeUid,
    "name": name,
    "duration": duration,
    "prices": priceJson,
  };

  try {
    await serviceRef.doc(docId).set(servicesJson, SetOptions(merge: true));
    return ServicesModel.fromJson(servicesJson);
  } on FirebaseException catch (e) {
    if (context.mounted) {
      COSnackBar.show(context, title: e.message ?? internalServerErrorMessage);
    }
  } catch (e) {
    if (context.mounted) {
      COSnackBar.show(context, title: e.toString());
    }
  }

  return null;
}

Future<ServicesModel> firebaseGetServiceById(String serviceId) async {
  CollectionReference serviceRef =
      FirebaseFirestore.instance.collection('services');
  final doc = await serviceRef
      .withConverter(
        fromFirestore: (snapshot, _) =>
            ServicesModel.fromJson({"id": snapshot.id, ...snapshot.data()!}),
        toFirestore: (service, _) => service.toJson(),
      )
      .doc(serviceId)
      .get();
  return doc.data()!;
}

Future<List<ServicesModel>> firebaseGetService(
  BuildContext context, {
  required String storeUid,
}) async {
  CollectionReference serviceRef =
      FirebaseFirestore.instance.collection('services');

  final servicesList = await serviceRef
      .withConverter(
        fromFirestore: (snapshot, _) =>
            ServicesModel.fromJson({"id": snapshot.id, ...snapshot.data()!}),
        toFirestore: (service, _) => service.toJson(),
      )
      .where("store_uid", isEqualTo: storeUid)
      .where('is_deleted', isEqualTo: false)
      .get();

  if (servicesList.docs.isEmpty) {
    return [];
  } else {
    return servicesList.docs.map((e) => e.data()).toList();
  }
}

Future<void> firebaseRemoveService(
  BuildContext context, {
  required String docId,
}) async {
  CollectionReference serviceRef =
      FirebaseFirestore.instance.collection('services');
  try {
    await serviceRef
        .doc(docId)
        .set({'is_deleted': true}, SetOptions(mergeFields: ['is_deleted']));
    if (context.mounted) {
      COSnackBar.show(context, title: "Remove service success");
    }
  } on FirebaseException catch (e) {
    if (context.mounted) {
      COSnackBar.show(context, title: e.message ?? internalServerErrorMessage);
    }
    return;
  }
}
