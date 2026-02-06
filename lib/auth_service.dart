import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

/// A centralized service for handling all Firebase Authentication logic.
class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// A stream that notifies listeners about changes to the user's sign-in state.
  static Stream<User?> get userStream => _auth.authStateChanges();

  /// Gets the currently signed-in user, if any.
  static User? get currentUser => _auth.currentUser;

  /// Signs in the user anonymously.
  static Future<void> signInAnonymously() async {
    try {
      print("Attempting anonymous sign-in...");
      await _auth.signInAnonymously();
      print("Anonymous sign-in successful.");
    } catch (e) {
      print("ERROR: Anonymous sign-in failed: $e");
      throw Exception('Could not sign in as guest. Please try again.');
    }
  }

  /// Signs in the user with their Google account.
  static Future<void> signInWithGoogle() async {
    try {
      print("Attempting Google sign-in...");
      if (kIsWeb) {
        // For web, we use a popup flow.
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        await _auth.signInWithPopup(googleProvider);
      } else {
        // For mobile, we use the google_sign_in package.
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) {
          print("Google sign-in aborted by user.");
          return; // The user canceled the sign-in
        }
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _auth.signInWithCredential(credential);
      }
      print("Google sign-in successful.");
    } catch (e) {
      print("ERROR: Google sign-in failed: $e");
      throw Exception('Google sign-in failed. Please check your connection and try again.');
    }
  }

  /// Placeholder for Facebook Sign-In.
  static Future<void> signInWithFacebook() async {
    print("Facebook sign-in is not implemented.");
    throw Exception('Facebook sign-in is not yet available.');
  }

  /// Placeholder for GitHub Sign-In.
  static Future<void> signInWithGitHub() async {
    print("GitHub sign-in is not implemented.");
    throw Exception('GitHub sign-in is not yet available.');
  }

  /// Signs out the current user from all services.
  static Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
      print("Signed out from Google.");
    } catch (e) {
      print("Error signing out from Google: $e");
    }
    // Always sign out from Firebase last.
    await _auth.signOut();
    print("Signed out from Firebase.");
  }
}
