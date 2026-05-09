import 'package:chalk_it_up/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const ChalkItUpApp());
    expect(find.text('🎱 Chalk It Up'), findsOneWidget);
  });
}
