part of 'firebase.dart';

Future<void> firebaseUpdateFollowStore(
  BuildContext context, {
  required bool isAdded,
  required String userId,
  required StoreModel store,
}) async {
  CollectionReference storeRef =
      FirebaseFirestore.instance.collection('stores');
  DocumentReference doc = storeRef.doc(store.id);

  try {
    if (isAdded) {
      await doc.update({
        'follows': FieldValue.arrayUnion([userId]),
      });
    } else {
      await doc.update({
        'follows': FieldValue.arrayRemove([userId]),
      });
    }
  } on FirebaseException catch (e) {
    if (context.mounted) {
      COSnackBar.show(context, title: e.message ?? internalServerErrorMessage);
    }
  }
}

Future<void> firebaseUpdateRatingStore(
  BuildContext context, {
  required StoreModel model,
  required RateModel rate,
}) async {
  CollectionReference storeRef =
      FirebaseFirestore.instance.collection('stores');
  DocumentReference doc = storeRef.doc(model.id);

  //Calculate rating
  int numb = model.numberOfService;
  double clean = model.rate.clean * numb;
  double fee = model.rate.fee * numb;
  double haste = model.rate.haste * numb;
  double service = model.rate.service * numb;

  clean = clean + rate.clean;
  fee = fee + rate.fee;
  haste = haste + rate.haste;
  service = service + rate.service;

  numb = numb + 1;
  clean = clean / numb;
  fee = fee / numb;
  haste = haste / numb;
  service = service / numb;

  try {
    await doc.set({
      'number_of_service': numb,
      'rate': RateModel(clean: clean, fee: fee, haste: haste, service: service)
          .toJson(),
    }, SetOptions(merge: true));
  } on FirebaseException catch (e) {
    if (context.mounted) {
      COSnackBar.show(context, title: e.message ?? internalServerErrorMessage);
    }
  }
}

Future<List<StoreModel>> firebaseGetAllStore() async {
  CollectionReference storeRef =
      FirebaseFirestore.instance.collection('stores');
  final storeList = await storeRef
      .withConverter(
        fromFirestore: (snapshot, _) =>
            StoreModel.fromJson({"id": snapshot.id, ...snapshot.data()!}),
        toFirestore: (stores, _) => stores.toJson(),
      )
      .get();

  return storeList.docs.map((doc) => doc.data()).toList();
}

Future<StoreModel> firebaseGetStoreByUid(String storeId) async {
  CollectionReference storeRef =
      FirebaseFirestore.instance.collection('stores');
  final storeList = await storeRef
      .doc(storeId)
      .withConverter(
        fromFirestore: (snapshot, _) =>
            StoreModel.fromJson({"id": snapshot.id, ...snapshot.data()!}),
        toFirestore: (stores, _) => stores.toJson(),
      )
      .get();

  return storeList.data()!;
}

Future<StoreModel?> firebaseGetStore(String userId) async {
  CollectionReference storeRef =
      FirebaseFirestore.instance.collection('stores');
  final storeList = await storeRef
      .withConverter(
        fromFirestore: (snapshot, _) =>
            StoreModel.fromJson({"id": snapshot.id, ...snapshot.data()!}),
        toFirestore: (stores, _) => stores.toJson(),
      )
      .where('user_id', isEqualTo: userId)
      .get();

  if (storeList.docs.isEmpty) {
    return null;
  } else {
    return storeList.docs.first.data();
  }
}

Future<bool> firebaseUpdateStore(
  BuildContext context, {
  required String userId,
  required String name,
  required String promotion,
  required LatLng location,
  required String open,
  required String close,
  required int slot,
  required int numberOfService,
  RateModel? rate,
  required List<String> follows,
  File? storeDisplayImage,
  File? qrImage,
  String? storeDisplayImageUrl,
  String? qrImageUrl,
}) async {
  CollectionReference storeRef =
      FirebaseFirestore.instance.collection('stores');
  final storeList = await storeRef
      .withConverter(
        fromFirestore: (snapshot, _) =>
            StoreModel.fromJson({"id": snapshot.id, ...snapshot.data()!}),
        toFirestore: (stores, _) => stores.toJson(),
      )
      .where('user_id', isEqualTo: userId)
      .get();

  String? storeDisplayImageURL = storeDisplayImageUrl;
  String? qrImageURL = qrImageUrl;

  final storageRef = FirebaseStorage.instance.ref();
  final storeDisplayImageRef =
      storageRef.child("images/store-image-$userId.jpg");
  final qrImageRef = storageRef.child("images/qr-image-$userId.jpg");

  try {
    if (storeDisplayImage != null) {
      await storeDisplayImageRef.putFile(storeDisplayImage);
    }
    if (qrImage != null) {
      await qrImageRef.putFile(qrImage);
    }
  } on FirebaseException catch (e) {
    if (context.mounted) {
      COSnackBar.show(context, title: e.message ?? internalServerErrorMessage);
    }
    return false;
  }
  if (storeDisplayImage != null) {
    storeDisplayImageURL = await storeDisplayImageRef.getDownloadURL();
  }
  if (qrImage != null) {
    qrImageURL = await qrImageRef.getDownloadURL();
  }

  Map<String, dynamic> updateJson = {
    "user_id": userId,
    "name": name,
    "location": GeoPoint(location.latitude, location.longitude),
    "promotion": promotion,
    "open": open,
    "close": close,
    "slot": slot,
    "rate": rate != null ? rate.toJson() : const RateModel().toJson(),
    "follows": follows,
    "number_of_service": numberOfService,
    "displayPhoto": storeDisplayImageURL,
    "photoURL": qrImageURL,
  };

  try {
    if (storeList.docs.isEmpty) {
      //Not have store we need to add them
      await storeRef.add(updateJson);
    } else {
      //update current store;
      await storeRef
          .doc(storeList.docs.first.id)
          .set(updateJson, SetOptions(merge: true));
    }
  } on FirebaseException catch (e) {
    if (context.mounted) {
      COSnackBar.show(context, title: e.message ?? internalServerErrorMessage);
    }
    return false;
  }

  if (context.mounted) {
    COSnackBar.show(context, title: "success");
  }
  return true;
}
