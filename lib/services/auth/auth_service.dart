import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //sign in
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      /*   _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
        },
        
      ); 
      */
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> showWrongPasswordDialog({required BuildContext context}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Error'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Naay na wrong pag type paki balik usab.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }

  Future<UserCredential> signUpWithEmailPassword(
      String email, password, dname) async {
    try {
      // isulod sa literal na fireauth
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      //ibutang nis firestore
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'name': dname,
          'email': email,
          'image':
              'https://firebasestorage.googleapis.com/v0/b/umconnect-bba25.appspot.com/o/images%2FdefaultIcon.jpg?alt=media&token=8908b86e-217d-49f2-bbbf-a90aba2e31ec',
        },
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    }
  }

  Future<void> showError({required BuildContext context}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Prevents dismissing the dialog with a tap outside of it
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Naay na wrong sa among code.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }

  Future<void> showNoInputDialog({required BuildContext context}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Prevents dismissing the dialog with a tap outside of it
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Error'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Butanga pd og email og pass no.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }

  Future<void> showExistingEmailDialog({required BuildContext context}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Prevents dismissing the dialog with a tap outside of it
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Signup Error'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Email already exists.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }

  //muhawa or mag signout
  Future<void> signOut() async {
    return await _auth.signOut();
  }
}
