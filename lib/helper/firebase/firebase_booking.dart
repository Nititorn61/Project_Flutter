part of 'firebase.dart';

Future<BookingModel> firebaseGetBooking(
  BuildContext context, {
  required String storeId,
  required String date,
  required int slot,
}) async {
  CollectionReference bookingRef =
      FirebaseFirestore.instance.collection('bookings');
  final bookingList = await bookingRef
      .withConverter(
        fromFirestore: (snapshot, _) =>
            BookingModel.fromJson({"id": snapshot.id, ...snapshot.data()!}),
        toFirestore: (bookings, _) => bookings.toJson(),
      )
      .where('store_id', isEqualTo: storeId)
      .where('date', isEqualTo: date)
      .where('slot', isEqualTo: slot)
      .limit(1)
      .get();

  if (bookingList.docs.isEmpty) {
    return BookingModel(
      id: bookingRef.doc().id,
      storeId: storeId,
      date: date,
      slot: slot,
      reserved: [],
    );
  } else {
    return bookingList.docs.first.data();
  }
}

Future<void> firebaseUpdateBooking(
  BuildContext context, {
  required String id,
  required String storeId,
  required String date,
  required int slot,
  required List<int> reserved,
}) async {
  CollectionReference bookingRef =
      FirebaseFirestore.instance.collection('bookings');

  DocumentReference docRef = bookingRef.doc(id);
  await docRef.set(
    BookingModel(
      id: id,
      storeId: storeId,
      date: date,
      slot: slot,
      reserved: reserved,
    ).toJson(),
    SetOptions(merge: true),
  );
}

Future<void> firebaseRemoveOtherBooking(
  BuildContext context, {
  required String resvId,
  required String bookingId,
  required String storeId,
  required String date,
  required int slot,
  required List<int> reserved,
}) async {
  CollectionReference bookingRef =
      FirebaseFirestore.instance.collection('bookings');

  CollectionReference reservationRef =
      FirebaseFirestore.instance.collection('reservations');

  final docs = await reservationRef
      .withConverter(
        fromFirestore: (snapshot, _) =>
            ReservationModel.fromJson({"id": snapshot.id, ...snapshot.data()!}),
        toFirestore: (reservations, _) => reservations.toJson(),
      )
      .where('store_id', isEqualTo: storeId)
      .where('store_slot', isEqualTo: slot)
      .where('date', isEqualTo: date)
      .where('status', isEqualTo: "รอการยืนยัน")
      .get();

  await Future.wait(
    docs.docs.map(
      (e) {
        bool isRemove = false;
        final snapshot = e.data();
        for (int i = 0; i < snapshot.duration; i++) {
          if (reserved.contains(snapshot.timeSlot + i)) {
            isRemove = true;
          }
        }
        if (isRemove) {
          return reservationRef
              .doc(e.id)
              .update({"status": reservationStatusList.last});
        } else {
          return Future(() => null);
        }
      },
    ),
  );

  DocumentReference docRef = bookingRef.doc(bookingId);
  BookingModel doc = (await docRef
          .withConverter(
            fromFirestore: (snapshot, _) =>
                BookingModel.fromJson({"id": snapshot.id, ...snapshot.data()!}),
            toFirestore: (bookings, _) => bookings.toJson(),
          )
          .get())
      .data()!;

  if (doc.reserved.isEmpty) {
    await docRef.set({'reserved': reserved}, SetOptions(merge: true));
  } else {
    await docRef.update({
      'reserved': FieldValue.arrayUnion(reserved),
    });
  }
}

Future<void> firebaseRemoveReservedTime(
  BuildContext context, {
  required String bookingId,
  required List<int> removed,
}) async {
  CollectionReference bookingRef =
      FirebaseFirestore.instance.collection('bookings');
  DocumentReference docRef = bookingRef.doc(bookingId);
  await docRef.update({
    'reserved': FieldValue.arrayRemove(removed),
  });
}
