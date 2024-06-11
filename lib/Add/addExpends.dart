import 'package:Wspend/getData/getDataRiwayat.dart';
import 'package:Wspend/home.dart';
import 'package:Wspend/provider/Notifikasi.dart';
import 'package:Wspend/provider/inputMoney.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddExpendesPage extends StatefulWidget {
  const AddExpendesPage({super.key});

  @override
  State<AddExpendesPage> createState() => _AddExpendesPageState();
}

class _AddExpendesPageState extends State<AddExpendesPage> {
  String _selectedCategory = '';
  TextEditingController amount = TextEditingController();
  num userLimit = 0;

  void validasi(String category) async {
    num limit = await getLimit();
    setState(() {
      userLimit = limit;
    });

    if (num.tryParse(amount.text.replaceAll(",", "")) != null) {
      num amountValue = num.parse(amount.text.replaceAll(",", ""));

      if (amountValue <= limit) {
        simpan(category);
        print('Data tersimpan');
      } else {
        // Tampilkan AlertDialog jika jumlah melebihi batas
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Peringatan'),
              content: const Text('Jumlah melebihi batas limit.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Tampilkan AlertDialog jika input tidak valid
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Peringatan'),
            content: const Text('Jumlah tidak valid.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    NotificationHelper.initializeNotifications();
    _fetchUserLimit();
  }

  void _fetchUserLimit() async {
    num limit = await getLimit();
    setState(() {
      userLimit = limit;
    });

  }

   void _showSavedData(num expends, num limit) {
  num remainingBalance = limit - expends;
  
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Data Tersimpan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pengeluaran Anda hari ini: $expends'),
            const SizedBox(height: 8),
            Text('Saldo Anda sisa: $remainingBalance'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Home(), // Navigasi ke halaman Home
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
          .collection('expends')
          .orderBy('list', descending: true)
          .limit(1)
          .get();

      int lastList = 0;
      if (querySnapshot.docs.isNotEmpty) {
        lastList = querySnapshot.docs.first['list'];
      }

      int newList = lastList - 1;

      // Save the new document with the incremented 'list' value
      await FirebaseFirestore.instance
          .collection('transaksi')
          .doc(currentUser.uid)
          .collection('expends')
          .add({
        'uid': currentUser.uid,
        'list': newList,
        'amount': int.parse(am.replaceAll(",", "")),
        'category': category,
        'timestamp': timestamp,
      });


      double amountValue = double.parse(am.replaceAll(",", ""));

      _showSavedData(amountValue, userLimit);
      NotificationHelper.showExpendsNotification(amountValue);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Add Expends',
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
                    CurrencyInputFormatter()
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Expends',
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
                    validasi(_selectedCategory);
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
