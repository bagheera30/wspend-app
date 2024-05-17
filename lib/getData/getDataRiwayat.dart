import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

Future<QuerySnapshot<Object?>> getDataRiwayat(
    String collection, List angkaList, List riwayatList) async {
  final currentUser = FirebaseAuth.instance.currentUser!;
  try {
    QuerySnapshot<Object?> querySnapshot = await FirebaseFirestore.instance
        .collection('transaksi')
        .doc(currentUser.uid)
        .collection(collection)
        .get();
    List<DocumentSnapshot<Object?>> documents = querySnapshot.docs;

    for (var document in documents) {
      Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
      if (data != null) {
        int amount = data['amount'];
        int list = data['list'];
        angkaList.add(amount);
        riwayatList.add(list);
      }
    }

    return querySnapshot;
  } catch (e) {
    print('Error getting data: $e');
    rethrow; // Rethrow the error to be caught by the FutureBuilder
  }
}

Future<List<Map<String, dynamic>>> getData(String collect) async {
  List<Map<String, dynamic>> result = [];
  try {
    final currentUser = FirebaseAuth.instance.currentUser!;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('transaksi')
        .doc(currentUser.uid)
        .collection(collect)
        .get();
    List<QueryDocumentSnapshot> documents = snapshot.docs;

    for (var document in documents) {
      Timestamp timestamp = document['timestamp'];
      String month = DateFormat('MMMM').format(timestamp.toDate());
      String tahun = DateFormat('yyyy').format(timestamp.toDate());
      int amount = document['amount'];

      // Tambahkan bulan dan amount ke dalam list result
      result.add({'bulan': month, 'amount': amount, 'tahun': tahun});
    }
  } catch (e) {
    print('Terjadi kesalahan: $e');
  }

  return result;
}

Future<List<Map<String, dynamic>>> getDataByMonth(
    String bulan, String collect) async {
  List<Map<String, dynamic>> result = [];

  try {
    List<Map<String, dynamic>> data = await getData(collect);
    for (var item in data) {
      String month = item['bulan'];
// Menambahkan print untuk menampilkan bulan

      if (month == bulan) {
        // Filter data by the specified month
        // Add month and amount to the result list
        result.add({
          'bulan': month,
          'amount': item['amount'],
        });
      }
    }
  } catch (e) {
    print('Terjadi kesalahan: $e');
  }

  return result;
}

Future<num> sumSaldo(String collect) async {
  List<Map<String, dynamic>> data = await getData(collect);
  num totalAmount = 0;

  for (var item in data) {
    totalAmount += item['amount'] as num;
  }

  return totalAmount;
}

Future<num> sumSaldoByMoth(String bulan, String collect) async {
  List<Map<String, dynamic>> data = await getDataByMonth(bulan, collect);
  num totalAmount = 0;

  for (var item in data) {
    totalAmount += item['amount'] as num;
  }

  return totalAmount;
}
