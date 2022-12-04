import 'package:flutter_test/flutter_test.dart';
import 'package:palomansion/main.dart';
import 'package:palomansion/panel.dart';

import 'test_tools.dart';

void main() {
  testWidgets('Panel test', (tester) async {
    await tester.pumpWidget(wrap(const MainPage()));
    expect(find.byType(Panel), findsOneWidget);
  });
}