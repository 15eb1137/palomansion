import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:palomansion/panel.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '騒音ハック',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const MainPage(),
    );
  }
}

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends ConsumerState<MainPage> {
  StreamSubscription<NoiseReading>? _noiseSubscription;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _noiseSubscription?.cancel();
    super.dispose();
  }

  void onData(NoiseReading noiseReading) {
    setState(() {
      if (!ref.watch(isRecordingProvider)) {
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
  }

  Future<void> start() async {
    try {
      _noiseSubscription = ref.watch(noiseStreamProvider.stream).listen(onData);
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  Future<void> stop() async {
    try {
      if (_noiseSubscription != null) {
        await _noiseSubscription!.cancel();
        _noiseSubscription = null;
      }
      setState(() {
        ref.watch(isRecordingProvider.notifier).state = false;
      });
    } catch (err) {
      if (kDebugMode) {
        print('stopRecorder error: $err');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('騒音ハック'),
      ),
      body: Panel(),
      floatingActionButton: FloatingActionButton(
          backgroundColor:
              ref.watch(isRecordingProvider) ? Colors.red : Colors.green,
          onPressed: ref.watch(isRecordingProvider) ? stop : start,
          child: ref.watch(isRecordingProvider)
              ? const Icon(Icons.stop)
              : const Icon(Icons.mic)),
    );
  }
}

final noiseStreamProvider = StreamProvider<NoiseReading>((ref) {
  late NoiseMeter _noiseMeter;
  bool _isRecording = ref.watch(isRecordingProvider);
  void onError(Object error) {
    if (kDebugMode) {
      print(error.toString());
    }
    _isRecording = false;
  }

  _noiseMeter = NoiseMeter(onError);
  return _noiseMeter.noiseStream;
});

final isRecordingProvider = StateProvider((ref) {
  return false;
});
