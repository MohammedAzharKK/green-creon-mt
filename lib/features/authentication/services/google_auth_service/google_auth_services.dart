import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthServices {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static Future<void> signInWithGoogle(BuildContext context) async {
    try {
      await signOut(); // Sign out from any existing session

      // Trigger the authentication
      final GoogleSignInAccount? userDetails = await _googleSignIn.signIn();

      if (userDetails == null) {
        // User canceled the sign-in
        return;
      }

      // get auth details from request
      final GoogleSignInAuthentication googleAuth =
          await userDetails.authentication;

      // Create a new credential for Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      await FirebaseAuth.instance.signInWithCredential(credential);

      if (context.mounted) {
        // Navigate to home page after successful sign in
        context.goNamed("HomePage");
      }
    } catch (e) {
      if (context.mounted) {
        // Show error msg in snack bar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign in failed: ${e.toString()}')),
        );
      }
    }
  }

//signout
  static Future<void> signOut() async {
    try {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
        await FirebaseAuth.instance.signOut();
      }
    } catch (e) {
      log('Sign out failed: $e');
    }
  }
}
