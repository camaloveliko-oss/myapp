// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ai_business_agent/main.dart';

void main() {
  testWidgets('shows the Kazakhstan map experience', (tester) async {
    await tester.pumpWidget(const AiBusinessAgentApp());

    await tester.enterText(find.byType(TextField).first, 'demo');
    await tester.enterText(find.byType(TextField).last, 'demo');
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pumpAndSettle();

    expect(find.text('AI Business Agent'), findsWidgets);
    expect(find.text('Astana'), findsOneWidget);
    expect(find.text('Map'), findsOneWidget);
  });
}
