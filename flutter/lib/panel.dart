import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

typedef Decibel = int;

class Panel extends StatelessWidget {
  const Panel(this.decibels, {super.key});

  final List<Decibel> decibels;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 400,
          child: SfCartesianChart(
            series: getData(),
            primaryXAxis: CategoryAxis(
                majorGridLines:
                    const MajorGridLines(color: Colors.transparent)),
            primaryYAxis: CategoryAxis(isVisible: false),
            plotAreaBorderColor: Colors.transparent,
          ),
        ),
        Center(
          child: Column(children: [
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: '${decibels.last}',
                    style: const TextStyle(fontSize: 64)),
                const TextSpan(text: 'dB', style: TextStyle(fontSize: 16))
              ], style: const TextStyle(color: Colors.black)),
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(text: 'AVG:${decibels.average}dB'),
                const TextSpan(text: '|'),
                TextSpan(text: 'MAX:${decibels.max}dB'),
              ], style: const TextStyle(color: Colors.grey, fontSize: 20)),
            )
          ]),
        )
      ],
    );
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
      //magnificationはグラフを見やすくするためdBの定義的に正しい2.0の倍数にしてない
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
        yValueMapper: (datum, _) => datum.magnification,
        pointColorMapper: (datum, _) => getColorFromMode(datum.appearanceRate),
        width: 0.98,
      ),
    ];
  }
}

class NoiseLv {
  NoiseLv(this.decibel, this.magnification, this.appearanceRate);
  final int decibel;
  final double magnification;
  final double appearanceRate;
}
