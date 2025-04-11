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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // Listen to auth state changes
        stream: Supabase.instance.client.auth.onAuthStateChange,
      // Build  Screens based on auth state changes
        builder: (context, snapshot){
          // loading...
          if(snapshot.connectionState == ConnectionState.waiting){
            return Scaffold(
              body: Center(child: CircularProgressIndicator(),),
            );
          }

          // check if there's valid session currently
          final session = snapshot.hasData? snapshot.data!.session : null;
          final user = session?.user;
          final createdAt = DateTime.tryParse(user?.createdAt ?? '');
          final now = DateTime.now();
          final isNew = createdAt != null && now.difference(createdAt).inMinutes < 5;
          // instead of isNew check whether the username is there or not!!
          if(isNew){
            return NewUserDetails();
          }
          else if(session != null){
            return Home();
          }else{
            return expand_welcome();
          }
        }
    );
  }
}
