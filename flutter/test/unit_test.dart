import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'test_tools.dart';

void main() {
  group('Learning test', () {
    final data = List<double>.generate(100, (_) => Random().nextDouble());

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      initializeFakeRequestPermissions(Permission.microphone);
      initializeFakeSensorChannel('audio_streamer.eventChannel', data);
    });

    test('noise_meter', () async {
      expect(NoiseMeter.sampleRate, 44100);

      NoiseMeter noiseMeter = NoiseMeter();
      Stream<NoiseReading> stream = noiseMeter.noiseStream;

      double getDb(double pcmValue) {
        // const refSoundPress = 0.00002;
        final inversed = pow(2, 15) * pcmValue;
        double log10(double x) => log(x) * log10e;
        return 20 * log10(inversed /* / refSoundPress */);
      }

      stream.listen((noiseReading) async {
        expect(stream.isBroadcast, isTrue);
        expect(
            getSignificantFigures(noiseReading.meanDecibel, 5),
            getSignificantFigures(
                getDb(0.5 * (data.min.abs() + data.max.abs())), 5));
        expect(getSignificantFigures(noiseReading.maxDecibel, 5),
            getSignificantFigures(getDb(data.max), 5));
      });
    });
  });
}
