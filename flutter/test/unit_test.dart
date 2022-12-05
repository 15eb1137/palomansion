import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noise_meter/noise_meter.dart';

import 'test_tools.dart';

void main() {
  group('Learning test', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    test('noise_meter', () async {
      const MethodChannel('flutter.baseflow.com/permissions/methods')
          .setMockMethodCallHandler((methodCall) async {
        if (methodCall.method == 'requestPermissions') {
          return <dynamic, dynamic>{
            // Permission.microphone.request().isGranted(7) を True(1) にする
            7: 1,
          };
        }
        return null;
      });
      double getDb(double pcmValue) => 20 * log(pow(2, 15) * pcmValue) / ln10;
      const data = <double>[1.0, 2.0, 3.0];
      initializeFakeSensorChannel('audio_streamer.eventChannel', data);
      NoiseMeter noiseMeter = NoiseMeter();
      Stream<NoiseReading> stream = noiseMeter.noiseStream;
      stream.listen((noiseReading) async {
        debugPrint(noiseReading.toString());
        await expectLater(stream.isBroadcast, isTrue);
        expect(noiseReading.meanDecibel.round(), getDb(data.average).round());
        expect(noiseReading.maxDecibel, getDb(data.max));
      });
    });
  });
}
