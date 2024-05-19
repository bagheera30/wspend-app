import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LimitPage extends StatefulWidget {
  const LimitPage({super.key});

  @override
  State<LimitPage> createState() => _LimitPageState();
}

class _LimitPageState extends State<LimitPage> {
  final TextEditingController _limitc = TextEditingController();
  final userC = FirebaseAuth.instance.currentUser!;
  void submit(int newLimit) {
    try {
      final userDocument =
          FirebaseFirestore.instance.collection('users').doc(userC.uid);

      userDocument.get().then((snapshot) {
        if (snapshot.exists) {
          userDocument
              .set({
                'limit': newLimit,
              }, SetOptions(merge: true))
              .then((value) => print('Limit updated successfully'))
              .catchError((error) => print('Failed to update limit: $error'));
        } else {
          userDocument
              .update({
                'limit': newLimit,
              })
              .then((value) => print('Limit updated successfully'))
              .catchError((error) => print('Failed to update limit: $error'));
        }
      });
    } catch (e) {
      print('Error updating limit: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[600],
        elevation: 0,
        centerTitle: true,
        leading: Container(), // Menghilangkan tombol kembali
        title: Text('Limit pengeluaran',
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            )),
      ),
      body: Container(
        color: Colors.yellow[600],
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Silakan masukkan limit yang Anda inginkan:',
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            const SizedBox(height: 16),
            TextField(
              controller: _limitc,
              decoration: const InputDecoration(
                labelText: 'Limit pengeluaran',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () async {
                  submit(int.parse(_limitc.text));
                },
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
