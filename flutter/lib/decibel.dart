import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noise_meter/noise_meter.dart';

import 'panel.dart';

class Decibels extends ConsumerWidget {
  const Decibels({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRecording = ref.watch(isRecordingProvider);

    ref.watch(noiseStreamProvider).whenData((noiseReading) {
      if (!isRecording) {
        ref.watch(isRecordingProvider.notifier).state = true;
      }
      if (noiseReading.maxDecibel > 0) {
        ref
            .watch(decibelProvider.notifier)
            .update((state) => state..add(noiseReading.maxDecibel));
        // 一時的にmaxを使うけど、最終的には代表せず全部使うことになりそう
        // 未補正の値
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('騒音ハック'),
      ),
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

final decibelProvider = StateProvider<List<double>>((ref) => [0.0]);
