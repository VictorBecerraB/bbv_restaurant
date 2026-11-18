import 'package:flutter/material.dart';

import '../models/mesa.dart';
import '../theme/app_theme.dart';

class MesaCard extends StatelessWidget {
  final Mesa mesa;
  final VoidCallback onTap;

  const MesaCard({super.key, required this.mesa, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = mesa.estado.color;
    final texto = Theme.of(context).textTheme;

    String detalle;
    switch (mesa.estado) {
      case EstadoMesa.libre:
        detalle = '${mesa.asientos} lugares';
        break;
      case EstadoMesa.ocupada:
        detalle = '${mesa.comensales} pers · ${mesa.minutos} min';
        break;
      case EstadoMesa.porCobrar:
        detalle = '\$${mesa.total!.toStringAsFixed(2)}';
        break;
    }

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color.withAlpha(90), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Mesa ${mesa.numero}',
                      style: texto.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                ],
              ),
              Text(mesa.zona, style: texto.bodySmall?.copyWith(color: AppColors.muted)),
              const Spacer(),
              Icon(Icons.table_restaurant, color: color, size: 34),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(mesa.estado.etiqueta,
                    style: texto.labelMedium?.copyWith(color: color, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 4),
              Text(detalle, style: texto.bodySmall?.copyWith(color: AppColors.dark)),
            ],
          ),
        ),
      ),
    );
  }
}
