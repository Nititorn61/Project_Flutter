import 'dart:io';

import 'package:car_okay/helper/snackbar/car_okay_snack_bar.dart';
import 'package:car_okay/models/application_user_model.dart';
import 'package:car_okay/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

Future<ApplicationUser> authUserHandle(UserCredential credential) async {
  CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
  final applicationUser = await usersRef
      .doc(credential.user!.uid)
      .withConverter(
        fromFirestore: (snapshot, _) =>
            ApplicationUser.fromJson({'id': snapshot.id, ...snapshot.data()!}),
        toFirestore: (appUser, _) => appUser.toJson(),
      )
      .get();

  //handle user not found inside application
  if (!applicationUser.exists) {
    final current = ApplicationUser.fromFirebaseCredentialAuth(credential);
    await usersRef.doc(credential.user!.uid).set(current.toJson());
    return current;
  } else {
    return applicationUser.data()!;
  }
}

Future<ApplicationUser> createAuthUserHandle(
  BuildContext context, {
  required UserCredential credential,
  required String username,
  required String firstName,
  required String lastName,
  required String phoneNumber,
  required File? imageFile,
}) async {
  CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
  User user = credential.user!;
  String? photoURL;

  final storageRef = FirebaseStorage.instance.ref();
  final photoRef = storageRef.child("images/${user.uid}.jpg");

  DocumentReference docRef = usersRef.doc(user.uid);

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

  final current = ApplicationUser(
    id: docRef.id,
    username: username,
    firstName: firstName,
    lastName: lastName,
    phoneNumber: phoneNumber,
    photoURL: photoURL ?? "",
    email: user.email!,
  );

  await docRef.set(current.toJson());

  return current;
}
