import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

      final user = userCredential.user;
      if (user != null) {
        await _cacheUserData(user.uid);
        await _logCachedUserData(); // Tambahkan untuk mencetak data user ke terminal
      }

      return user;
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
        await _cacheUserData(user.uid);
        await _logCachedUserData(); // Tambahkan untuk mencetak data user ke terminal
      }

      return user;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> _cacheUserData(String userId) async {
    final doc = await _firebaseFirestore.collection('users').doc(userId).get();
    final userData = doc.data();

    if (userData != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', userData['id']);
      await prefs.setString('user_name', userData['name']);
      await prefs.setString('user_phone', userData['phone']);
      await prefs.setString('user_email', userData['email']);
    }
  }

  Future<void> _logCachedUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final userName = prefs.getString('user_name');
    final userPhone = prefs.getString('user_phone');
    final userEmail = prefs.getString('user_email');

    print('Cached User ID: $userId');
    print('Cached User Name: $userName');
    print('Cached User Phone: $userPhone');
    print('Cached User Email: $userEmail');
  }

  Future<Map<String, String?>> getCachedUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final userName = prefs.getString('user_name');
    final userPhone = prefs.getString('user_phone');
    final userEmail = prefs.getString('user_email');

    return {
      'user_id': userId,
      'user_name': userName,
      'user_phone': userPhone,
      'user_email': userEmail,
    };
  }
}
