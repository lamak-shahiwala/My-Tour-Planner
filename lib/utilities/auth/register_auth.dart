import 'package:firebase_auth/firebase_auth.dart';

Future<String> register_auth(String name, String email, String password) async {
  if (email.isEmpty || password.isEmpty || name.isEmpty) {
    return 'emptyFields';
  }

  try {
    UserCredential userCredential =
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    String userId = userCredential.user!.uid;
    print("User ID: $userId");

    return 'true';
  } on FirebaseAuthException catch (e) {
    print("Firebase Auth Error: ${e.message}");

    if (e.code == 'email-already-in-use') {
      return 'emailAlreadyUsed';
    } else if (e.code == 'invalid-email') {
      return "invalidEmail";
    } else if (e.code == 'weak-password') {
      return "weakPassword";
    }
    return 'unexpectedError';
  }
}
