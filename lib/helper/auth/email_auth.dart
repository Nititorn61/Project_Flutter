import 'package:car_okay/helper/snackbar/car_okay_snack_bar.dart';
import 'package:car_okay/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<UserCredential?> createUserWithEmailAndPassword(
  BuildContext context,
  String email,
  String password,
) async {
  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential;
  } on FirebaseAuthException catch (e) {
    if (context.mounted) {
      COSnackBar.show(context, title: e.message ?? "Something went wrong");
    }
    // if (e.code == 'weak-password') {
    //   COSnackBar.show(context, title: 'The password provided is too weak.');
    // } else if (e.code == 'email-already-in-use') {
    //   COSnackBar.show(context,
    //       title: 'The account already exists for that email.');
    // }
    return null;
  } catch (e) {
    if (context.mounted) {
      COSnackBar.show(context, title: e.toString());
    }
    return null;
  }
}

Future<UserCredential?> signInWithEmailAndPassword(
  BuildContext context,
  String email,
  String password,
) async {
  try {
    return await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  } on FirebaseAuthException catch (e) {
    COSnackBar.show(context, title: e.message ?? internalServerErrorMessage);

    // if (e.code == 'user-not-found') {
    //   COSnackBar.show(context, title: 'No user found for that email.');
    // } else if (e.code == 'wrong-password') {
    //   COSnackBar.show(context, title: 'Wrong password provided for that user.');
    // }
    return null;
  } catch (e) {
    COSnackBar.show(context, title: e.toString());
    return null;
  }
}
