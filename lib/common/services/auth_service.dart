import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream to check auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
    String email, 
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Sign up with email and password
  Future<UserCredential> signUpWithEmailAndPassword(
    String email, 
    String password,
  ) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // reset password
Future<void> resetPassword(String email) async {
  try {
    await _auth.sendPasswordResetEmail(email: email);
  } catch (e) {
    throw Exception(e.toString());
  }
}

  // Get current user
  User? get currentUser => _auth.currentUser;
}
