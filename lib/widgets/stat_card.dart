import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class StatCard extends StatelessWidget {
  final String titulo;
  final int valor;
  final Color color;
  final IconData icono;

  const StatCard({
    super.key,
    required this.titulo,
    required this.valor,
    required this.color,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icono, color: color, size: 22),
            const SizedBox(height: 8),
            Text('$valor',
                style: texto.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: AppColors.dark)),
            Text(titulo, style: texto.bodySmall?.copyWith(color: AppColors.muted)),
          ],
        ),
      ),
    );
  }
}
