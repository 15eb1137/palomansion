import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

typedef Decibel = int;

class Panel extends StatelessWidget {
  const Panel(this.decibels, {super.key});

  final List<double> decibels;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SfCartesianChart(title: ChartTitle(text: ''), series: getData()),
      const Text(''), // Latest dB big
      const Text(''), // Detail Avg & Max dB
      const Text('') // dB size description
    ]);
  }

  static Color getColorFromMode(double rate) {
    if (rate > 0.875) {
      return Colors.green;
    } else if (rate > 0.75) {
      return Colors.teal;
    } else if (rate > 0.625) {
      return Colors.blue;
    } else if (rate > 0.5) {
      return Colors.lightBlue;
    } else if (rate > 0.375) {
      return Colors.cyan;
    } else if (rate > 0.25) {
      return Colors.yellow;
    } else if (rate > 0.125) {
      return Colors.orange;
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
      NoiseLv(50, 1, 8 / 30),
      NoiseLv(60, 2, 10 / 30),
      NoiseLv(70, 4, 5 / 30),
      NoiseLv(80, 8, 4 / 30),
      NoiseLv(90, 16, 2 / 30),
      NoiseLv(100, 32, 1 / 30),
      NoiseLv(110, 64, 0 / 30),
      NoiseLv(120, 128, 0 / 30)
    ];
    return <ColumnSeries<NoiseLv, Decibel>>[
      ColumnSeries(
          dataSource: data,
          xValueMapper: (datum, _) => datum.decibel,
          yValueMapper: (datum, _) => datum.num,
          pointColorMapper: (datum, _) =>
              getColorFromMode(datum.appearanceRate)),
    ];
  }
}

class NoiseLv {
  NoiseLv(this.decibel, this.num, this.appearanceRate);
  final int decibel;
  final double num;
  final double appearanceRate;
}
