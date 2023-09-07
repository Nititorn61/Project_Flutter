part of 'firebase.dart';

Future<List<ReservationModel>> firebaseGetDoneReservation(
  BuildContext context, {
  required String storeId,
}) async {
  try {
    CollectionReference reservationRef =
        FirebaseFirestore.instance.collection('reservations');

    final docs = await reservationRef
        .withConverter(
          fromFirestore: (snapshot, _) => ReservationModel.fromJson(
              {"id": snapshot.id, ...snapshot.data()!}),
          toFirestore: (reservations, _) => reservations.toJson(),
        )
        .where('store_id', isEqualTo: storeId)
        .where('status', isEqualTo: "เสร็จสิ้น")
        .orderBy('date', descending: true)
        .get();

    return docs.docs.map((doc) => doc.data()).toList();
  } on FirebaseException catch (e) {
    if (context.mounted) {
      // print(e.message);
      COSnackBar.show(context, title: e.message ?? internalServerErrorMessage);
    }
    return [];
  }
}

Future<void> firebaseUpdateReservationRating(
  BuildContext context, {
  required RateModel rate,
  required ReservationModel model,
}) async {
  CollectionReference reservationRef =
      FirebaseFirestore.instance.collection('reservations');
  DocumentReference doc = reservationRef.doc(model.id);

  Map<String, dynamic> update = {
    "is_rated": true,
    "rate": rate.toJson(),
  };

  try {
    await doc.update(update);
    if (context.mounted) {
      COSnackBar.show(context, title: "อัพเดทสถานะสำเร็จ");
    }
    return;
  } on FirebaseException catch (e) {
    if (context.mounted) {
      COSnackBar.show(context, title: e.message ?? internalServerErrorMessage);
    }
    return;
  }
}

Future<bool> firebaseUpdateStatusReservation(
  BuildContext context, {
  required String reservationId,
  required String status,
  bool isIncrementNumberOfService = false,
}) async {
  CollectionReference reservationRef =
      FirebaseFirestore.instance.collection('reservations');
  DocumentReference doc = reservationRef.doc(reservationId);

  Map<String, dynamic> update = {"status": status};

  try {
    await doc.update(update);
    if (context.mounted) {
      COSnackBar.show(context, title: "อัพเดทสถานะสำเร็จ");
    }
    return true;
  } on FirebaseException catch (e) {
    if (context.mounted) {
      COSnackBar.show(context, title: e.message ?? internalServerErrorMessage);
    }
    return false;
  }
}

Future<List<ReservationModel>> firebaseGetListReservation(
  BuildContext context, {
  required String storeId,
}) async {
  CollectionReference reservationRef =
      FirebaseFirestore.instance.collection('reservations');

  final reservationList = await reservationRef
      .withConverter(
        fromFirestore: (snapshot, _) =>
            ReservationModel.fromJson({"id": snapshot.id, ...snapshot.data()!}),
        toFirestore: (reservations, _) => reservations.toJson(),
      )
      .where('store_id', isEqualTo: storeId)
      .orderBy('status')
      .orderBy('date', descending: true)
      .orderBy('time_slot')
      .get();

  if (reservationList.docs.isEmpty) {
    return [];
  } else {
    return reservationList.docs.map((e) => e.data()).toList();
  }
}

Future<List<ReservationModel>> firebaseGetReservation(
  BuildContext context, {
  required String userId,
}) async {
  CollectionReference reservationRef =
      FirebaseFirestore.instance.collection('reservations');

  final reservationList = await reservationRef
      .withConverter(
        fromFirestore: (snapshot, _) =>
            ReservationModel.fromJson({"id": snapshot.id, ...snapshot.data()!}),
        toFirestore: (reservations, _) => reservations.toJson(),
      )
      .where('user_id', isEqualTo: userId)
      .orderBy('date', descending: true)
      .orderBy('time_slot')
      .orderBy('status')
      .get();

  if (reservationList.docs.isEmpty) {
    return [];
  } else {
    return reservationList.docs.map((e) => e.data()).toList();
  }
}

Future<void> firebaseAddReservation(
  BuildContext context, {
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
}) async {
  CollectionReference reservationRef =
      FirebaseFirestore.instance.collection('reservations');
  String? photoURL;

  DocumentReference doc = reservationRef.doc();
  final storageRef = FirebaseStorage.instance.ref();
  final photoRef = storageRef.child("images/${doc.id}.jpg");
  try {
    await photoRef.putFile(imageFile);
  } on FirebaseException catch (e) {
    if (context.mounted) {
      COSnackBar.show(context, title: e.message ?? internalServerErrorMessage);
    }
    return;
  }
  photoURL = await photoRef.getDownloadURL();

  try {
    await doc.set({
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
      "is_rated": false,
      "rate": const RateModel().toJson(),
    }, SetOptions(merge: true));
    if (context.mounted) {
      COSnackBar.show(context, title: "จองสำเร็จ");
    }
    return;
  } on FirebaseException catch (e) {
    if (context.mounted) {
      COSnackBar.show(context, title: e.message ?? internalServerErrorMessage);
    }
  } catch (e) {
    if (context.mounted) {
      COSnackBar.show(context, title: e.toString());
    }
  }
}
