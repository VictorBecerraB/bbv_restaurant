import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Estados de mesa (tabla `tables`, columna `status`).
enum EstadoMesa { libre, ocupada, porCobrar }

extension EstadoMesaUI on EstadoMesa {
  String get etiqueta {
    switch (this) {
      case EstadoMesa.libre:
        return 'Libre';
      case EstadoMesa.ocupada:
        return 'Ocupada';
      case EstadoMesa.porCobrar:
        return 'Por cobrar';
    }
  }

  Color get color {
    switch (this) {
      case EstadoMesa.libre:
        return AppColors.libre;
      case EstadoMesa.ocupada:
        return AppColors.ocupada;
      case EstadoMesa.porCobrar:
        return AppColors.porCobrar;
    }
  }
}

class Mesa {
  final int numero;
  final String zona;
  final int asientos;
  final EstadoMesa estado;
  final int? comensales;
  final int? minutos;
  final double? total;
  final String? mesero;

  const Mesa({
    required this.numero,
    required this.zona,
    required this.asientos,
    required this.estado,
    this.comensales,
    this.minutos,
    this.total,
    this.mesero,
  });
}
