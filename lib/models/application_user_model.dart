import 'package:firebase_auth/firebase_auth.dart';

class ApplicationUser {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String photoURL;
  final String email;
  final String username;

  const ApplicationUser({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.photoURL,
    required this.email,
  });

  factory ApplicationUser.fromJson(Map<String, Object?> json) {
    return ApplicationUser(
        id: json["id"] as String,
        username: json["username"] as String,
        firstName: json["firstName"] as String,
        lastName: json["lastName"] as String,
        phoneNumber: json["phoneNumber"] as String,
        photoURL: json["photoURL"] as String,
        email: json["email"] as String);
  }

  Map<String, Object?> toJson() {
    return {
      "id": id,
      "username": username,
      "firstName": firstName,
      "lastName": lastName,
      "phoneNumber": phoneNumber,
      "photoURL": photoURL,
      "email": email,
    };
  }

  ApplicationUser.fromFirebaseCredentialAuth(UserCredential u)
      : this(
          id: u.user!.uid,
          username: "",
          firstName: u.user!.displayName ?? "",
          lastName: "",
          phoneNumber: u.user!.phoneNumber ?? "",
          photoURL: u.user!.photoURL ?? "",
          email: u.user!.email ?? "",
        );
}
