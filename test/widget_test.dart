import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_info_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const DoctorInfoApp());
    // Verify the splash screen shows the app name
    expect(find.text('Doctor Info App'), findsOneWidget);
  });
}
