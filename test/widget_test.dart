import 'package:flutter_test/flutter_test.dart';
import 'package:nimitham/main.dart';

void main() {
  testWidgets('Nimitham app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const NimithamApp());
    expect(find.text('நிமித்தம்'), findsOneWidget);
  });
}
