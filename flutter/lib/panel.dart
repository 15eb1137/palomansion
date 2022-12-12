import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

typedef Decibel = double;

class Panel extends StatelessWidget {
  const Panel(this.decibels, {super.key});

  final List<Decibel> decibels;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 450,
        child: Stack(
          children: [
            SizedBox(
              height: 400,
              child: SfCartesianChart(
                series: getData(decibels),
                primaryXAxis: CategoryAxis(
                  majorGridLines:
                      const MajorGridLines(color: Colors.transparent),
                ),
                primaryYAxis: CategoryAxis(isVisible: false),
                plotAreaBorderColor: Colors.transparent,
              ),
            ),
            Positioned(
              left: 20,
              top: 48,
              child: Column(children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: decibels.last.toStringAsFixed(0),
                        style: const TextStyle(fontSize: 64)),
                    const TextSpan(text: 'dB', style: TextStyle(fontSize: 16))
                  ], style: const TextStyle(color: Colors.black)),
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'AVG:${decibels.average.toStringAsFixed(1)}dB'),
                    const TextSpan(text: '｜'),
                    TextSpan(text: 'MAX:${decibels.max.toStringAsFixed(1)}dB'),
                  ], style: const TextStyle(color: Colors.grey, fontSize: 20)),
                )
              ]),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Text('少'),
                Container(
                  width: 250,
                  height: 30,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: FractionalOffset.centerRight,
                      end: FractionalOffset.centerLeft,
                      colors: [
                        Colors.teal,
                        Colors.green,
                        Colors.lightGreen,
                        Colors.lime,
                        Colors.yellow,
                        Colors.orange,
                        Colors.deepOrange,
                        Colors.red
                      ],
                    ),
                  ),
                ),
                const Text('多'),
              ]),
            ),
          ],
        ));
  }

  static Color getColorFromMode(double rate) {
    if (rate > 0.75) {
      return Colors.teal;
    } else if (rate > 0.5) {
      return Colors.green;
    } else if (rate > 0.31) {
      return Colors.lightGreen;
    } else if (rate > 0.16) {
      return Colors.lime;
    } else if (rate > 0.07) {
      return Colors.yellow;
    } else if (rate > 0.02) {
      return Colors.orange;
    } else if (rate > 0.01) {
      return Colors.deepOrange;
    } else if (rate > 0) {
      return Colors.red;
    } else if (rate == 0) {
      return Colors.grey;
    } else {
      return Colors.white;
    }
  }

  static List<ColumnSeries<NoiseLv, int>> getData(List<Decibel> decibels) {
    final total = decibels.length;
    int getFreq(int binWidth, List<Decibel> decibels) => decibels
        .where((db) => (binWidth / 10).floor() == (db / 10).floor())
        .length;
    double getMag(int exp) => pow(1.5, exp).toDouble();
    final data = <NoiseLv>[
      //magnificationはグラフを見やすくするためdBの定義的に正しい2.0の倍数にしてない
      NoiseLv(10, getMag(1), getFreq(10, decibels) / total),
      NoiseLv(20, getMag(2), getFreq(20, decibels) / total),
      NoiseLv(30, getMag(3), getFreq(30, decibels) / total),
      NoiseLv(40, getMag(4), getFreq(40, decibels) / total),
      NoiseLv(50, getMag(5), getFreq(50, decibels) / total),
      NoiseLv(60, getMag(6), getFreq(60, decibels) / total),
      NoiseLv(70, getMag(7), getFreq(70, decibels) / total),
      NoiseLv(80, getMag(8), getFreq(80, decibels) / total),
      NoiseLv(90, getMag(9), getFreq(90, decibels) / total),
      NoiseLv(100, getMag(10), getFreq(100, decibels) / total),
      NoiseLv(110, getMag(11), getFreq(110, decibels) / total),
      NoiseLv(120, getMag(12), getFreq(120, decibels) / total),
    ];
    return <ColumnSeries<NoiseLv, int>>[
      ColumnSeries(
        dataSource: data,
        xValueMapper: (datum, _) => datum.decibel.toInt(),
        yValueMapper: (datum, _) => datum.magnification,
        pointColorMapper: (datum, _) => getColorFromMode(datum.appearanceRate),
        width: 0.98,
      ),
    ];
  }
}

class NoiseLv {
  NoiseLv(this.decibel, this.magnification, this.appearanceRate);
  final Decibel decibel;
  final double magnification;
  final double appearanceRate;
}
