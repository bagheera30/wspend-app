import 'package:Wspend/winget/customChart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:Wspend/getData/getDataRiwayat.dart';
// Import widget CustomChart

class Graphdata extends StatefulWidget {
  final String bulan;
  final String tahun;

  const Graphdata({Key? key, required this.bulan, required this.tahun})
      : super(key: key);

  @override
  _GraphdataState createState() => _GraphdataState();
}

class _GraphdataState extends State<Graphdata> {
  late List<Map<String, dynamic>> incomeData = [];
  late List<Map<String, dynamic>> expendsData = [];
  Future<num>? totalIncome;
  Future<num>? totalExpends;

  @override
  void initState() {
    super.initState();
    fetchData();
    totalIncome = sumSaldoByMoth(widget.bulan, 'income', widget.tahun);
    totalExpends = sumSaldoByMoth(widget.bulan, 'expends', widget.tahun);
  }

  final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

  Future<void> fetchData() async {
    try {
      incomeData =
          await getDataByMonthAndYears(widget.bulan, 'income', widget.tahun);
      expendsData =
          await getDataByMonthAndYears(widget.bulan, 'expends', widget.tahun);
      setState(() {});
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Grafik pengeluaran dan pendapatan',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.yellow,
      ),
      body: incomeData.isNotEmpty && expendsData.isNotEmpty
          ? Container(
              height: 1000,
              color: Colors.yellow,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(50),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          FutureBuilder<num>(
                            future: totalIncome,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                final incomeTotal = snapshot.data;
                                return SizedBox(
                                  width: 130,
                                  child: TextFormField(
                                    initialValue:
                                        formatCurrency.format(incomeTotal ?? 0),
                                    decoration: const InputDecoration(
                                      labelText: 'Total Income',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 3.0),
                                      ),
                                    ),
                                    readOnly: true,
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(width: 50),
                          FutureBuilder<num>(
                            future: totalExpends,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                final expendsTotal = snapshot.data;
                                return SizedBox(
                                  width: 130,
                                  child: TextFormField(
                                    initialValue:
                                        formatCurrency.format(expendsTotal),
                                    decoration: const InputDecoration(
                                      labelText: 'Total Expends',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 2.0),
                                      ),
                                    ),
                                    readOnly: true,
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(width: 50),
                          FutureBuilder<num>(
                            future: totalExpends,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                final expendsTotal = snapshot.data;
                                return SizedBox(
                                  width: 130,
                                  child: TextFormField(
                                    initialValue:
                                        formatCurrency.format(expendsTotal),
                                    decoration: const InputDecoration(
                                      labelText: 'Total Expends',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 2.0),
                                      ),
                                    ),
                                    readOnly: true,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: CustomChart(
                              chartData: incomeData,
                              name: "income",
                            ),
                          ),
                          const SizedBox(width: 20), // Jarak antara dua grafik
                          Expanded(
                            child: CustomChart(
                              chartData: expendsData,
                              name: "Expends",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            )
          : Container(
              color: Colors.yellow,
              child: const Center(
                  child: Text('Maaf, data yang Anda masukkan tidak ditemukan')),
            ),
    );
  }
}
