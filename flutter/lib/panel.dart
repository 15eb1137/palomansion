import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

typedef Decibel = int;

class Panel extends StatelessWidget {
  const Panel(this.decibel, {super.key});

  final double decibel;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SfCartesianChart(title: ChartTitle(text: ''), series: getData()),
      const Text(''), // Big dB
      const Text(''), // Detail Avg & Max dB
      const Text('') // dB size description
    ]);
  }

  static List<ColumnSeries<NoiseLv, Decibel>> getData() {
    final graphShape = <NoiseLv>[
      NoiseLv(50, 1),
      NoiseLv(60, 2),
      NoiseLv(70, 4),
      NoiseLv(80, 8),
      NoiseLv(90, 16),
      NoiseLv(100, 32),
      NoiseLv(110, 64),
      NoiseLv(120, 128)
    ];
    return <ColumnSeries<NoiseLv, Decibel>>[
      ColumnSeries(
          dataSource: graphShape,
          xValueMapper: (datum, _) => datum.decibel,
          yValueMapper: (datum, _) => datum.num)
    ];
  }
}

class NoiseLv {
  NoiseLv(this.decibel, this.num);
  final int decibel;
  final double num;
}
