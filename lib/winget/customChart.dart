import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CustomChart extends StatelessWidget {
  final List<Map<String, dynamic>> chartData;
  final String name;

  CustomChart({required this.chartData, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300, // Atur tinggi grafik sesuai kebutuhan
      width: 500, // Atur lebar grafik sesuai kebutuhan
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <LineSeries<Map<String, dynamic>, String>>[
          LineSeries<Map<String, dynamic>, String>(
            dataSource: chartData,
            xValueMapper: (datum, _) => datum['tanggal'].toString(),
            yValueMapper: (datum, _) => datum['amount'],
            name: name,
            color: name == 'income' ? Colors.blue : Colors.red,
            width: 2,
          ),
        ],
        legend: Legend(isVisible: true),
      ),
    );
  }
}
