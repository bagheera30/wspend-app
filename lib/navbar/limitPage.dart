import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LimitPage extends StatefulWidget {
  const LimitPage({Key? key}) : super(key: key);

  @override
  State<LimitPage> createState() => _LimitPageState();
}

class _LimitPageState extends State<LimitPage> {
  final TextEditingController _limitController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[600],
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Limit Pengeluaran',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Container(), // Menghilangkan tombol kembali
      ),
      body: Container(
        color: Colors.yellow[600],
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Masukkan limit yang Anda inginkan:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _limitController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Limit Pengeluaran',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  submitLimit();
                },
                child: Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submitLimit() async {
    try {
      if (_limitController.text.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Peringatan'),
              content: Text('Mohon masukkan limit pengeluaran.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      final int newLimit = int.parse(_limitController.text.trim());

      final userDocument =
          FirebaseFirestore.instance.collection('users').doc(user!.uid);

      // Menghitung jumlah hari dalam bulan ini
      final now = DateTime.now();
      final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);

      // Memperbarui limit harian
      final double dailyLimit = newLimit / daysInMonth;

      final Map<String, dynamic> data = {
        'limit': dailyLimit,
      };

      // Memeriksa apakah dokumen pengguna sudah ada di Firestore
      final DocumentSnapshot snapshot = await userDocument.get();

      if (snapshot.exists) {
        await userDocument.update(data);
      } else {
        await userDocument.set(data);
      }

      // Menampilkan pesan sukses
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sukses'),
            content: Text('Limit pengeluaran berhasil diperbarui.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Menampilkan pesan error jika terjadi masalah
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Terjadi kesalahan: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
