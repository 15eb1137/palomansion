import 'package:flutter_test/flutter_test.dart';
import 'package:palomansion/decibel.dart';
import 'package:palomansion/main.dart';

import 'test_tools.dart';

void main() {
  testWidgets('MainPage test', (tester) async {
    await tester.pumpWidget(wrap(const MainPage()));
    expect(find.byType(Decibels), findsOneWidget);
  });
  testWidgets('Decibels test', (tester) async {
    await tester.pumpWidget(wrap(const Decibels()));
    expect(find.textContaining(RegExp(r'^0dB$'), findRichText: true),
        findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.textContaining(RegExp(r'^0dB$'), findRichText: true),
        findsNothing);
  });
}
