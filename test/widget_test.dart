import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mayson/main.dart';

void main() {
  testWidgets('Login then open doctors and pharmacies', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(TextFormField).at(0), 'admin');
    await tester.enterText(find.byType(TextFormField).at(1), '123456');
    await tester.tap(find.text('دخول'));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    await tester.tap(find.text('الأطباء'));
    await tester.pumpAndSettle();
    expect(find.text('د. أحمد محمود'), findsOneWidget);

    await tester.tap(find.text('د. سارة علي'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('هل يستقبل المندوبين؟'));
    await tester.pumpAndSettle();
    expect(find.text('لا، لا يستقبل المندوبين.'), findsOneWidget);
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('الصيدليات'));
    await tester.pumpAndSettle();
    expect(find.text('صيدلية الشفاء'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'النور');
    await tester.pumpAndSettle();
    expect(find.text('صيدلية النور'), findsOneWidget);
    expect(find.text('صيدلية الشفاء'), findsNothing);
  });
}
