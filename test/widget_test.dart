import 'package:flutter_test/flutter_test.dart';
import 'package:cycle_guard/app.dart';

void main() {
  testWidgets('CycleGuard app starts', (WidgetTester tester) async {
    await tester.pumpWidget(const ChariPiApp());
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('CycleGuard'), findsWidgets);
  });
}
