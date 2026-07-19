import 'package:flutter_test/flutter_test.dart';
import 'package:furenglish/app.dart';

void main() {
  testWidgets('App renders search page', (WidgetTester tester) async {
    await tester.pumpWidget(const FurEnglishApp());
    expect(find.text('FurEnglish'), findsOneWidget);
  });
}
