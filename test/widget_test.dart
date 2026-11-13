import 'package:flutter_test/flutter_test.dart';
import 'package:mimbar_app/main.dart';

void main() {
  testWidgets('MimbarApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MimbarApp());
    expect(find.byType(MimbarApp), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 4));
  });
}
