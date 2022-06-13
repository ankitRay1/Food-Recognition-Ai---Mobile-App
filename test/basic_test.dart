import 'package:flutter_test/flutter_test.dart';

import 'package:foodie_pedia/main.dart';

void main() {
  testWidgets('App Starts', (WidgetTester tester) async {
    await tester.pumpWidget(const SmoothApp());
    expect(find.byType(SmoothApp), findsOneWidget);
  });
}
