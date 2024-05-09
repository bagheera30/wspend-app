import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Future<User?> signInWithGoogle() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;
    try {
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication?.idToken,
          accessToken: googleSignInAuthentication?.accessToken);

      UserCredential result =
          await firebaseAuth.signInWithCredential(credential);

      final user = result.user;
      print(user);
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'id': user.uid,
          'name': user.displayName,
          'email': user.email,
          'photoURL': user.photoURL,
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
