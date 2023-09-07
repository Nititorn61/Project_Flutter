import 'dart:convert';
import 'dart:io';

import 'package:car_okay/helper/auth/auth_user_handle.dart';
import 'package:car_okay/helper/auth/email_auth.dart';
import 'package:car_okay/helper/auth/google_auth.dart';
import 'package:car_okay/helper/firebase/firebase.dart';
import 'package:car_okay/helper/navigator/car_okay_navigator.dart';
import 'package:car_okay/helper/snackbar/car_okay_snack_bar.dart';
import 'package:car_okay/models/application_user_model.dart';
import 'package:car_okay/pages/home_page.dart';
import 'package:car_okay/pages/auth/login_page.dart';
import 'package:car_okay/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthCubit extends Cubit<ApplicationUser?> {
  final _storage = const FlutterSecureStorage();
  AuthCubit() : super(null);

  String getUserId() {
    if (state != null) {
      return state!.id;
    }
    return "";
  }

  Future<String> getNameByUuid(String uuid) async {
    return await firebaseFindNameByUuid(uuid);
  }

  Future<void> forgetPassword(
    BuildContext context, {
    required String email,
  }) async {
    try {
      await sendPasswordReset(email);
      if (!context.mounted) return;
    } on FirebaseAuthException catch (e) {
      COSnackBar.show(context, title: e.message ?? "Internal server error");
      return;
    } catch (e) {
      COSnackBar.show(context, title: e.toString());
      return;
    }
    if (context.mounted) {
      COSnackBar.show(context, title: "Reset password link send to $email");
    }
  }

  Future<void> checkAuth(BuildContext context) async {
    await _storage.read(key: userStorageKey).then((jsonApplicationUser) {
      if (jsonApplicationUser != null) {
        try {
          ApplicationUser applicationUser =
              ApplicationUser.fromJson(jsonDecode(jsonApplicationUser));
          CONavigator.pushReplacement(context, const HomePage());
          emit(applicationUser);
        } catch (e) {
          // print(e);
          _storage.deleteAll().then((_) {
            CONavigator.pushReplacement(context, const LoginPage());
          });
        }
      } else {
        CONavigator.pushReplacement(context, const LoginPage());
      }
    });
  }

  Future<bool> createUser(
    BuildContext context, {
    required String email,
    required String password,
    required String username,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required File? imageFile,
  }) async {
    final userCredential =
        await createUserWithEmailAndPassword(context, email, password);

    if (userCredential == null) return false;
    if (context.mounted) {
      ApplicationUser applicationUser = await createAuthUserHandle(
        context,
        credential: userCredential,
        username: username,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        imageFile: imageFile,
      );
      //User
      if (context.mounted) {
        _storage
            .write(
          key: userStorageKey,
          value: jsonEncode(applicationUser.toJson()),
        )
            .then((_) {
          CONavigator.push(context, const HomePage());
        });
      }
      emit(applicationUser);
    }
    return false;
  }

  Future<void> updateUser(
    BuildContext context, {
    required String id,
    // required String email,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required File? imageFile,
  }) async {
    if (context.mounted) {
      ApplicationUser applicationUser = await updateFirebaseUser(
        context,
        id: id,
        // email: email,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        imageFile: imageFile,
      );
      //User
      if (context.mounted) {
        _storage
            .write(
          key: userStorageKey,
          value: jsonEncode(applicationUser.toJson()),
        )
            .then((_) {
          CONavigator.push(context, const HomePage());
        });
      }
      emit(applicationUser);
    }
  }

  Future<void> emailSignIn(
    BuildContext context, {
    required String emailOrUsername,
    required String password,
  }) async {
    UserCredential? userCredential;

    if (emailOrUsername.contains("@")) {
      userCredential =
          await signInWithEmailAndPassword(context, emailOrUsername, password);
    } else {
      final user = await findEmailByUsername(emailOrUsername);
      if (user != null && context.mounted) {
        userCredential =
            await signInWithEmailAndPassword(context, user.email, password);
      } else {
        //User not found but we need error from firebase
        if (context.mounted) {
          userCredential =
              await signInWithEmailAndPassword(context, "1@1.com", password);
        }
      }
    }

    if (userCredential == null) return;
    if (context.mounted) {
      _handleAuthenticateUser(context, userCredential);
    }
  }

  Future<void> googleSignIn(BuildContext context) async {
    final userCredential = await signInWithGoogle();
    if (userCredential.user != null) {
      if (context.mounted) {
        _handleAuthenticateUser(context, userCredential);
      }
    }
  }

  Future<void> logout(BuildContext context) async {
    await Future.wait([
      FirebaseAuth.instance.signOut(),
      GoogleSignIn().signOut(),
      _storage.deleteAll(),
    ]).then((_) {
      CONavigator.pushReplacement(context, const LoginPage());
      emit(null);
    });
  }

  Future<void> _handleAuthenticateUser(
    BuildContext context,
    UserCredential userCredential,
  ) async {
    ApplicationUser applicationUser = await authUserHandle(userCredential);
    emit(applicationUser);

    if (context.mounted) {
      _storage
          .write(
        key: userStorageKey,
        value: jsonEncode(applicationUser.toJson()),
      )
          .then((_) async {
        CONavigator.push(context, const HomePage());
      });
    }
  }
}
