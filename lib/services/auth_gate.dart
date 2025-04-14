/*
AUTH GATE -

---------------------------------------------------------------------------------------------

unauthenticated -> expand_welcome
authenticated   -> Home Screen
 */

import 'package:flutter/material.dart';
import 'package:my_tour_planner/screens/home/home.dart';
import 'package:my_tour_planner/screens/intro/welcome.dart';
import 'package:my_tour_planner/screens/user_details/new_user_details.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<bool> getUserName() async {
    final SupabaseClient _supabase = Supabase.instance.client;

    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return false;

    final data = await _supabase
        .from('Profile')
        .select('username')
        .eq('user_id', userId)
        .maybeSingle();

    if (data != null && data['username'] != null && data['username'].toString().isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final session = snapshot.data?.session;

        // If not authenticated, go to welcome screen
        if (session == null) {
          return expand_welcome();
        }

        // If authenticated, check if user is new
        return FutureBuilder<bool>(
          future: getUserName(),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (asyncSnapshot.hasError) {
              return Scaffold(
                body: Center(child: Text("Error: ${asyncSnapshot.error}")),
              );
            }

            final isNew = asyncSnapshot.data == false;

            if (isNew) {
              return NewUserDetails();
            } else {
              return Home();
            }
          },
        );
      },
    );
  }
}
