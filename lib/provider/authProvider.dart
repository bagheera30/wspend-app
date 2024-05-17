import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<User?> signUp(
      String name, String phone, String email, String password) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        await _firebaseFirestore.collection('users').doc(user.uid).set({
          'id': user.uid,
          'name': name,
          'phone': phone,
          'email': email,
        });
      }

      return user;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
