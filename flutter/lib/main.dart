import 'package:flutter/material.dart';
import 'package:palomansion/panel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '騒音ハック',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('騒音ハック'),
        ),
        body: const Panel(
            [54, 56, 75, 63, 67, 95, 73, 60, 40, 60, 67, 63, 70, 56, 73, 84]));
  }
}
