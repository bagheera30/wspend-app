import 'package:Wspend/intro.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Future.delayed(const Duration(seconds: 3));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'MultiSellerSquare',
      home: Intro(),
      debugShowCheckedModeBanner: false,
    );
  }
}
