
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cuatro_retos_flutter/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CuatroRetosApp());

    // Verificar que el contrador inicie en 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verificar que el contador haya incrementado a 1.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
