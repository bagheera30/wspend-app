import 'package:Wspend/home.dart';
import 'package:Wspend/provider/Notifikasi.dart';
import 'package:Wspend/provider/inputMoney.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddIncomePage extends StatefulWidget {
  const AddIncomePage({super.key});

  @override
  State<AddIncomePage> createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  String _selectedCategory = '';
  TextEditingController amount = TextEditingController();

  void _showSavedData() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Data Tersimpan'),
          content: const Text('Data income telah disimpan.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const Home(), // Navigasi ke halaman Regis
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void simpan(String category) async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final timestamp = FieldValue.serverTimestamp();
    final am = amount.text.trim();
    if (am.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please insert all')),
      );
      return;
    }
    try {
      // Get the last document in the 'income' collection
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('transaksi')
          .doc(currentUser.uid)
          .collection('income')
          .orderBy('list', descending: true)
          .limit(1)
          .get();

      int lastList = 0;
      if (querySnapshot.docs.isNotEmpty) {
        lastList = querySnapshot.docs.first['list'];
      }

      int newList = lastList + 1;
      String c = am.replaceAll(",", "");

      // Save the new document with the incremented 'list' value
      await FirebaseFirestore.instance
          .collection('transaksi')
          .doc(currentUser.uid)
          .collection('income')
          .add({
        'uid': currentUser.uid,
        'list': newList,
        'amount': int.parse(c),
        'category': category,
        'timestamp': timestamp,
      });

      _showSavedData();
      double amount = double.parse(c);
      NotificationHelper.showIncomeNotification(amount);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    NotificationHelper.initializeNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Add Income',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.yellow[600],
      ),
      body: SafeArea(
        child: Container(
          color: Colors.yellow[600],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: amount,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    // Fit the validating format.
                    //fazer o formater para dinheiro
                    CurrencyInputFormatter()
                  ],
                  decoration: const InputDecoration(
                    labelText: 'income',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Pilih Kategori',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _selectedCategory = 'food';
                            });
                          },
                          icon: const Icon(Icons.fastfood_rounded),
                          color: _selectedCategory == 'food'
                              ? Colors.green
                              : Colors.grey,
                        ),
                        const Text('Food'),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _selectedCategory = 'shopping';
                            });
                          },
                          icon: const Icon(Icons.shopping_cart),
                          color: _selectedCategory == 'shopping'
                              ? Colors.green
                              : Colors.grey,
                        ),
                        const Text('Shopping'),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _selectedCategory = 'bills';
                            });
                          },
                          icon: const Icon(Icons.receipt),
                          color: _selectedCategory == 'bills'
                              ? Colors.green
                              : Colors.grey,
                        ),
                        const Text('Bills'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    simpan(_selectedCategory);
                    print(_selectedCategory);
                  },
                  child: const Text('Simpan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
