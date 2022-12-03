import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

typedef Decibel = int;

class Panel extends StatelessWidget {
  const Panel(this.decibels, {super.key});

  final List<double> decibels;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SfCartesianChart(
        title: ChartTitle(text: ''),
        series: getData(),
        primaryXAxis: CategoryAxis(
            majorGridLines: const MajorGridLines(color: Colors.transparent)),
        primaryYAxis: CategoryAxis(isVisible: false),
        plotAreaBorderColor: Colors.transparent,
      ),
      const Text(''), // Latest dB big
      const Text(''), // Detail Avg & Max dB
      const Text('') // dB size description
    ]);
  }

  static Color getColorFromMode(double rate) {
    if (rate > 0.875) {
      return Colors.teal;
    } else if (rate > 0.75) {
      return Colors.green;
    } else if (rate > 0.625) {
      return Colors.lightGreen;
    } else if (rate > 0.5) {
      return Colors.lime;
    } else if (rate > 0.375) {
      return Colors.yellow;
    } else if (rate > 0.25) {
      return Colors.orange;
    } else if (rate > 0.125) {
      return Colors.deepOrange;
    } else if (rate > 0) {
      return Colors.red;
    } else if (rate == 0) {
      return Colors.grey;
    } else {
      return Colors.white;
    }
  }

  static List<ColumnSeries<NoiseLv, Decibel>> getData() {
    final data = <NoiseLv>[
      NoiseLv(50, pow(1.5, 1).toDouble(), 80 / 30),
      NoiseLv(60, pow(1.5, 2).toDouble(), 100 / 30),
      NoiseLv(70, pow(1.5, 3).toDouble(), 25 / 30),
      NoiseLv(80, pow(1.5, 4).toDouble(), 14 / 30),
      NoiseLv(90, pow(1.5, 5).toDouble(), 8 / 30),
      NoiseLv(100, pow(1.5, 6).toDouble(), 1 / 30),
      NoiseLv(110, pow(1.5, 7).toDouble(), 0 / 30),
      NoiseLv(120, pow(1.5, 8).toDouble(), 0 / 30)
    ];
    return <ColumnSeries<NoiseLv, Decibel>>[
      ColumnSeries(
        dataSource: data,
        xValueMapper: (datum, _) => datum.decibel,
        yValueMapper: (datum, _) => datum.num,
        pointColorMapper: (datum, _) => getColorFromMode(datum.appearanceRate),
        width: 0.98,
      ),
    ];
  }
}

class NoiseLv {
  NoiseLv(this.decibel, this.num, this.appearanceRate);
  final int decibel;
  final double num;
  final double appearanceRate;
}
