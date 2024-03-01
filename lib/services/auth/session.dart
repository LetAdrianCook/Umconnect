import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import 'package:um_connect/services/auth/logreg.dart';
import "package:um_connect/tabs/home.dart";

class Session extends StatelessWidget {
  const Session({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              String? email = FirebaseAuth.instance.currentUser?.email;
              print('User email: $email');
              return Home();
            } else {
              return const LogReg();
            }
          }),
    );
  }
}
