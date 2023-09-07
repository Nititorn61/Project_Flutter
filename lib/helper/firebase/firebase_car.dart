part of 'firebase.dart';

Future<CarModel?> firebaseGetCarById({required String carId}) async {
  try {
    final carDoc = await FirebaseFirestore.instance
        .collection('cars')
        .withConverter(
          fromFirestore: (snapshot, _) =>
              CarModel.fromJson({"id": snapshot.id, ...snapshot.data()!}),
          toFirestore: (cars, _) => cars.toJson(),
        )
        .doc(carId)
        .get();

    return carDoc.data();
  } on FirebaseException catch (_) {
    return null;
  }
}

Future<List<CarModel>> getCarListForUser(String userId) async {
  CollectionReference carsRef = FirebaseFirestore.instance.collection('cars');
  try {
    final carsList = await carsRef
        .withConverter(
          fromFirestore: (snapshot, _) =>
              CarModel.fromJson({"id": snapshot.id, ...snapshot.data()!}),
          toFirestore: (cars, _) => cars.toJson(),
        )
        .where('user_id', isEqualTo: userId)
        .get();

    if (carsList.docs.isEmpty) {
      return [];
    } else {
      return carsList.docs.map((e) => e.data()).toList();
    }
  } on FirebaseException catch (_) {
    return [];
  }
}

Future<void> fireBaseRemoveCar(
  BuildContext context, {
  required CarModel car,
}) async {
  CollectionReference carsRef = FirebaseFirestore.instance.collection('cars');
  final storageRef = FirebaseStorage.instance.ref();

  DocumentReference carRef = carsRef.doc(car.id);
  final photoRef = storageRef.child("images/${car.id}.jpg");

  if (context.mounted) {
    try {
      await Future.wait([
        carRef.delete(),
        photoRef.delete(),
      ]);
      if (context.mounted) {
        COSnackBar.show(context, title: "Remove car success");
      }
    } on FirebaseException catch (e) {
      if (context.mounted) {
        COSnackBar.show(context,
            title: e.message ?? internalServerErrorMessage);
      }
      return;
    }
  }
}

Future<bool> fireBaseEditCar(
  BuildContext context, {
  required String id,
  required String carTypesId,
  required String plate,
  required File? imageFile,
}) async {
  CollectionReference carsRef = FirebaseFirestore.instance.collection('cars');
  DocumentReference docRef = carsRef.doc(id);

  String? photoURL;

  final storageRef = FirebaseStorage.instance.ref();
  final photoRef = storageRef.child("images/$id.jpg");

  //handle user not found inside application
  try {
    if (imageFile != null) {
      await photoRef.putFile(imageFile);
    }
  } on FirebaseException catch (e) {
    if (context.mounted) {
      COSnackBar.show(context, title: e.message ?? internalServerErrorMessage);
    }
    return false;
  }
  if (imageFile != null) {
    photoURL = await photoRef.getDownloadURL();
  }

  Map<String, dynamic> updateJson = {
    "car_types_id": carTypesId,
    "plate": plate,
  };

  if (photoURL != null) updateJson.addAll({"photoURL": photoURL});

  try {
    await docRef.set(updateJson, SetOptions(merge: true));
    return true;
  } on FirebaseException catch (e) {
    if (context.mounted) {
      COSnackBar.show(context, title: e.message ?? internalServerErrorMessage);
    }
  } catch (e) {
    if (context.mounted) {
      COSnackBar.show(context, title: e.toString());
    }
  }

  return false;
}

Future<bool> fireBaseAddCarToUser(
  BuildContext context, {
  required String userId,
  required String carTypesId,
  required String plate,
  required File? imageFile,
}) async {
  CollectionReference carsRef = FirebaseFirestore.instance.collection('cars');
  DocumentReference docRef = carsRef.doc();
  String? photoURL;

  final storageRef = FirebaseStorage.instance.ref();
  final photoRef = storageRef.child("images/${docRef.id}.jpg");

  //handle user not found inside application
  try {
    if (imageFile != null) {
      await photoRef.putFile(imageFile);
    }
  } on FirebaseException catch (e) {
    if (context.mounted) {
      COSnackBar.show(context, title: e.message ?? internalServerErrorMessage);
    }
    return false;
  }
  if (imageFile != null) {
    photoURL = await photoRef.getDownloadURL();
  }

  final current = CarModel(
    id: docRef.id,
    userId: userId,
    carTypesId: carTypesId,
    plate: plate,
    photoURL: photoURL,
  );
  try {
    await carsRef.add(current.toJson());
    return true;
  } on FirebaseException catch (e) {
    if (context.mounted) {
      COSnackBar.show(context, title: e.message ?? internalServerErrorMessage);
    }
  } catch (e) {
    if (context.mounted) {
      COSnackBar.show(context, title: e.toString());
    }
  }

  return false;
}
