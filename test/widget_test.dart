import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:bbv_restaurant/main.dart';

void main() {
  testWidgets('El login valida campos y entra a la pantalla de mesas', (tester) async {
    await tester.pumpWidget(const BBVRestaurantApp());

    expect(find.text('Tacos Brothers'), findsOneWidget);

    // Sin datos muestra validaciones
    await tester.tap(find.byKey(const Key('boton_login')));
    await tester.pump();
    expect(find.text('Escribe tu usuario'), findsOneWidget);

    // Credenciales de prueba
    await tester.enterText(find.byKey(const Key('campo_usuario')), 'luis');
    await tester.enterText(find.byKey(const Key('campo_pin')), '1234');
    await tester.tap(find.byKey(const Key('boton_login')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Hola, Luis'), findsOneWidget);
    expect(find.text('Mesas'), findsWidgets);
  });
}
