import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Panel extends StatelessWidget {
  const Panel(this.decibel, {super.key});

  final double decibel;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SfCartesianChart(),
      const Text(''), // Big dB
      const Text(''), // Detail Avg & Max dB
      const Text('') // dB size description
    ]);
  }
}
