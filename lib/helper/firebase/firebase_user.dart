part of 'firebase.dart';

Future<String> firebaseFindNameByUuid(String id) async {
  CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
  final applicationUser = await usersRef
      .doc(id)
      .withConverter(
        fromFirestore: (snapshot, _) =>
            ApplicationUser.fromJson(snapshot.data()!),
        toFirestore: (users, _) => users.toJson(),
      )
      .get();

  var user = applicationUser.data()!;
  return "${user.firstName} ${user.lastName}";
}

Future<ApplicationUser?> findEmailByUsername(String username) async {
  CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
  final applicationUser = await usersRef
      .withConverter(
        fromFirestore: (snapshot, _) =>
            ApplicationUser.fromJson({'id': snapshot.id, ...snapshot.data()!}),
        toFirestore: (users, _) => users.toJson(),
      )
      .where('username', isEqualTo: username)
      .limit(1)
      .get();

  if (applicationUser.docs.isEmpty) {
    return null;
  } else {
    return applicationUser.docs.first.data();
  }
}

Future<ApplicationUser> updateFirebaseUser(
  BuildContext context, {
  // required String email,
  required String id,
  required String firstName,
  required String lastName,
  required String phoneNumber,
  required File? imageFile,
}) async {
  CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
  String? photoURL;

  DocumentReference docRef = usersRef.doc(id);

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
  }
  if (imageFile != null) {
    photoURL = await photoRef.getDownloadURL();
  }

  Map<String, dynamic> updateJson = {
    "firstName": firstName,
    "lastName": lastName,
    "phoneNumber": phoneNumber,
    // email:email,
  };

  if (photoURL != null) updateJson.addAll({"photoURL": photoURL});

  await docRef.set(updateJson, SetOptions(merge: true));

  final result = await docRef
      .withConverter(
        fromFirestore: (snapshot, _) =>
            ApplicationUser.fromJson({"id": id, ...snapshot.data()!}),
        toFirestore: (users, _) => users.toJson(),
      )
      .get();

  return result.data()!;
}
