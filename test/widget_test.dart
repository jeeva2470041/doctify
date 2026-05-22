import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_info_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const DoctorInfoApp());
    // Verify the splash screen shows the app name
    expect(find.text('Dockify'), findsOneWidget);
    // Pump the timer for splash screen transition to complete
    await tester.pump(const Duration(seconds: 3));
    // Pump extra time for route transition to finish and dispose splash screen
    await tester.pump(const Duration(seconds: 1));
  });
}
