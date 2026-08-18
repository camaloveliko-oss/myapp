import 'package:flutter_test/flutter_test.dart';
import 'package:ai_business_agent/main.dart';

void main() {
  testWidgets('shows the onboarding and AI category options', (tester) async {
    await tester.pumpWidget(const AiBusinessAgentApp());

    expect(find.text('AI Business Agent'), findsWidgets);
    expect(find.text('Choose how you want to receive your OTP'), findsOneWidget);
    expect(find.text('Choose an AI category'), findsNothing);
    expect(find.text('Choose how you want to receive your OTP'), findsOneWidget);
  });
}
