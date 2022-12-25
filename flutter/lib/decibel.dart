import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noise_meter/noise_meter.dart';

import 'panel.dart';

class DecibelsPage extends ConsumerWidget {
  const DecibelsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRecording = ref.watch(isRecordingProvider);

    ref.watch(noiseStreamProvider).whenData((noiseReading) {
      if (!isRecording) {
        ref.watch(isRecordingProvider.notifier).state = true;
      }
      if (noiseReading.maxDecibel > 0) {
        ref.watch(decibelProvider).addDecibel(Decibel(noiseReading.maxDecibel));
        // 一時的にmaxを使うけど、最終的には代表せず全部使うことになりそう
        // 未補正の値
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('騒音ハック'),
      ),
      // ignore: prefer_const_constructors
      body: Panel(),
    );
  }
}

final noiseStreamProvider = StreamProvider<NoiseReading>((ref) {
  void onError(Object error) {
    if (kDebugMode) {
      print(error.toString());
    }
    ref.watch(isRecordingProvider.notifier).state = false;
  }

  return NoiseMeter(onError).noiseStream;
});

final isRecordingProvider = StateProvider((ref) => true);

final decibelProvider = StateProvider<RecordLog>((ref) =>
    RecordLog(id: RecordLogId('record_log_00'), decibels: [Decibel(0.0)]));

@immutable
class Decibel {
  Decibel(this.value) : assert(value.isFinite);

  final double value;
}

@immutable
class RecordLogId {
  RecordLogId(this.value) : assert(value.isNotEmpty);
  final String value;
}

class RecordLog {
  RecordLog({required this.id, required List<Decibel> decibels})
      : _decibels = decibels;
  final RecordLogId id;
  List<Decibel> _decibels;

  List<Decibel> get decibels => _decibels;

  void addDecibel(Decibel newDecibel) => _decibels = [..._decibels, newDecibel];
}
