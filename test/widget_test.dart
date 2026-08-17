import 'package:flutter_test/flutter_test.dart';
import 'package:rimrid_delivery/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const RimRidFoodApp());
    expect(find.text('RimRid Food'), findsWidgets);
  });
}
