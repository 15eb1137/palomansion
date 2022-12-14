import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palomansion/main.dart';
import 'package:palomansion/panel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'test_tools.dart';

void main() {
  testWidgets('MainPage test', (tester) async {
    await tester.pumpWidget(wrap(const MainPage()));
    expect(find.byType(Panel), findsOneWidget);
    expect(find.textContaining(RegExp(r'^0dB$'), findRichText: true),
        findsOneWidget);
    await tester.tap(find.byIcon(Icons.mic));
    await tester.pumpAndSettle();
    expect(find.textContaining(RegExp(r'^0dB$'), findRichText: true),
        findsNothing);
  });

  testWidgets('Panel test', (tester) async {
    await tester.pumpWidget(wrap(const Panel()));
    expect(find.byType(Text), findsWidgets);
    expect(find.byType(RichText), findsWidgets);
    expect(find.byType(SizedBox), findsWidgets);
    expect(find.byType(Positioned), findsOneWidget);
    expect(find.byType(SfCartesianChart), findsOneWidget);
    expect(
        find.byWidgetPredicate(
            (widget) => widget is Text && widget.data == '多'),
        findsOneWidget);
    expect(
        find.byWidgetPredicate(
            (widget) => widget is Text && widget.data == '少'),
        findsOneWidget);
  });
}
