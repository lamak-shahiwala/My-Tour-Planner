import 'package:firebase_auth/firebase_auth.dart';

Future<String> login_auth(
    context, String email, String password) async {
  if (email.isEmpty || password.isEmpty) {
    return 'emptyFields';
  }

  try {
    UserCredential userCredential =
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return 'true';
  } on FirebaseAuthException catch (e) {
    if (e.code == 'invalid-credential') {
      return "invalidCredentials";
    }
    return "unexpectedError";
  }
}