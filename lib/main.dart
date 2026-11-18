import 'package:flutter/material.dart';

import 'models/usuario.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const BBVRestaurantApp());
}

/// App de comandas de Tacos Brothers.
/// Avance 1: inicio de sesión y pantalla inicial (mapa de mesas).
class BBVRestaurantApp extends StatelessWidget {
  const BBVRestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BBV Restaurant',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (_) => const LoginScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == HomeScreen.routeName) {
          final usuario = settings.arguments as Usuario;
          return MaterialPageRoute(
            builder: (_) => HomeScreen(usuario: usuario),
          );
        }
        return null;
      },
    );
  }
}
