part of 'firebase.dart';

Future<List<CarTypes>> firebaseGetCarTypes() async {
  CollectionReference carsRef =
      FirebaseFirestore.instance.collection('car_types');
  final carTypesList = await carsRef
      .withConverter(
        fromFirestore: (snapshot, _) =>
            CarTypes.fromJson({'id': snapshot.id, ...snapshot.data()!}),
        toFirestore: (carTypes, _) => carTypes.toJson(),
      )
      .get();

  if (carTypesList.docs.isEmpty) {
    return [];
  } else {
    return carTypesList.docs.map((e) => e.data()).toList();
  }
}
