import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

    if (angkaList.isNotEmpty && riwayatList.isNotEmpty) {
      print(angkaList);
      print(riwayatList);
    } else {
      print('angkaList or riwayatList is empty');
    }

    return querySnapshot;
  } catch (e) {
    print('Error getting data: $e');
    throw e; // Rethrow the error to be caught by the FutureBuilder
  }
}
