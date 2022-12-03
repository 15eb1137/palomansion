import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Panel extends StatelessWidget {
  const Panel(this.decibel, {super.key});

  final double decibel;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SfCartesianChart(title: ChartTitle(text: ''), series: getDefaultData()),
      const Text(''), // Big dB
      const Text(''), // Detail Avg & Max dB
      const Text('') // dB size description
    ]);
  }

  static List<ColumnSeries<num, num>> getDefaultData() {
    final data = <num>[1, 2, 3, 4, 5];
    return <ColumnSeries<num, num>>[
      ColumnSeries(
          dataSource: data,
          xValueMapper: (datum, index) => datum,
          yValueMapper: (datum, index) => datum)
    ];
  }
}
