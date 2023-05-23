import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FirebaseBarChart extends StatelessWidget {
  final List<ChartData> chartData;

  FirebaseBarChart({required this.chartData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <BarSeries<ChartData, String>>[
          BarSeries<ChartData, String>(
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.date,
            yValueMapper: (ChartData data, _) => data.value,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.middle,
              labelPosition: ChartDataLabelPosition.inside,
              color: Colors.blueGrey[700],
            ),
          )
        ],
      ),
    );
  }
}

class ChartData {
  final String date;
  double value;

  ChartData(this.date, this.value);
}
