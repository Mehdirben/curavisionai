import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sign up user with Firebase Authentication
  static Future<bool> signup(String name, String email, String password) async {
    try {
      // Create a new user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update the user's display name
      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.reload();

      return true; // Sign up successful
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase exceptions
      if (e.code == 'email-already-in-use') {
        throw Exception('The email address is already in use by another account.');
      } else if (e.code == 'invalid-email') {
        throw Exception('The email address is not valid.');
      } else if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else {
        throw Exception('Sign up failed. Please try again later.');
      }
    } catch (e) {
      print("Unknown error during sign up: $e");
      throw Exception('An error occurred during sign up. Please try again later.');
    }
  }

  /// Login user with Firebase Authentication
  static Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true; // Login successful
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Incorrect password.');
      } else {
        throw Exception('Login failed. Please try again later.');
      }
    } catch (e) {
      print("Unknown error during login: $e");
      throw Exception('An error occurred during login. Please try again later.');
    }
  }

  /// Reset password using Firebase Authentication
  static Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true; // Reset link sent successfully
    } catch (e) {
      print("Error during password reset: $e");
      return false; // Reset link failed
    }
  }

  /// Sign out user
  static Future<void> signOut() async {
    await _auth.signOut();
  }
}