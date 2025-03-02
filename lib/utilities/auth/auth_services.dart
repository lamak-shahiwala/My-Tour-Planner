import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  // Log in with email and password
  Future<AuthResponse> logInWithEmailPassword(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
        email: email,
        password: password
    );
  }

  // Sign up with email and password
  Future<AuthResponse> signUpWithEmailPassword(String email, String password, String displayName) async {
    return await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
        'Display name': displayName, // Store display name in metadata
      },
    );
  }

  // Log out with email and password
  Future<void> logOut() async {
    await _supabase.auth.signOut();
  }

  Future<User?> nativeGoogleSignIn() async {
    const webClientId = '379837538347-v2tbkiumup7p5qatru3fk7g4nj3j6517.apps.googleusercontent.com';
    const iosClientId = '379837538347-0q590jrv53pmgcaglatcn0b80u23mfvs.apps.googleusercontent.com';
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: kIsWeb ? webClientId : null, // Fix: Avoid using TargetPlatform
      serverClientId: webClientId,
    );

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return null; // User canceled sign-in
    }

    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null || idToken == null) {
      throw 'Missing Google Auth tokens';
    }

    final response = await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    return response.user; // Return the authenticated user
  }

  // Get User's email
  String? getUserCreatedDate() {
    final session = _supabase.auth.currentSession;
    if (session == null) return null;
    return session.user.createdAt;
  }

}