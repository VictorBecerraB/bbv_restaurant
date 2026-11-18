import 'package:flutter/material.dart';

import '../data/datos_demo.dart';
import '../models/mesa.dart';
import '../models/usuario.dart';
import '../theme/app_theme.dart';
import '../widgets/mesa_card.dart';
import '../widgets/stat_card.dart';
import 'login_screen.dart';

/// Pantalla inicial: mapa de mesas del restaurante.
class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  final Usuario usuario;

  const HomeScreen({super.key, required this.usuario});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;
  String? _zona; // null = todas

  List<Mesa> get _mesasFiltradas =>
      _zona == null ? mesasDemo : mesasDemo.where((m) => m.zona == _zona).toList();

  int _contar(EstadoMesa estado) => mesasDemo.where((m) => m.estado == estado).length;

  void _proximamente(String funcion) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('$funcion: disponible en el siguiente avance'),
        behavior: SnackBarBehavior.floating,
      ));
  }

  Future<void> _cerrarSesion() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Seguro que quieres salir?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(100, 44)),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );
    if (confirmar == true && mounted) {
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    }
  }

  void _verMesa(Mesa mesa) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (ctx) {
        final texto = Theme.of(ctx).textTheme;
        final libre = mesa.estado == EstadoMesa.libre;
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Mesa ${mesa.numero}',
                      style: texto.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(width: 12),
                  Chip(
                    label: Text(mesa.estado.etiqueta),
                    labelStyle: TextStyle(color: mesa.estado.color, fontWeight: FontWeight.w700),
                    backgroundColor: mesa.estado.color.withAlpha(30),
                    side: BorderSide.none,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _Dato(icono: Icons.place_outlined, texto: 'Zona: ${mesa.zona}'),
              _Dato(icono: Icons.event_seat_outlined, texto: '${mesa.asientos} lugares'),
              if (!libre) ...[
                _Dato(icono: Icons.people_outline, texto: '${mesa.comensales} comensales'),
                _Dato(icono: Icons.timer_outlined, texto: '${mesa.minutos} min desde que se abrió'),
                _Dato(icono: Icons.badge_outlined, texto: 'Atiende: ${mesa.mesero}'),
                _Dato(
                  icono: Icons.payments_outlined,
                  texto: 'Cuenta: \$${mesa.total!.toStringAsFixed(2)}',
                ),
              ],
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  _proximamente(libre ? 'Abrir mesa y tomar orden' : 'Ver orden de la mesa');
                },
                icon: Icon(libre ? Icons.add : Icons.receipt_long),
                label: Text(libre ? 'Abrir mesa y tomar orden' : 'Ver orden'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final u = widget.usuario;
    final texto = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              child: Text(u.iniciales, style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hola, ${u.nombre.split(' ').first}',
                    style: texto.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                Text('${u.rol.etiqueta} · Tacos Brothers',
                    style: texto.bodySmall?.copyWith(color: AppColors.muted)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Notificaciones',
            onPressed: () => _proximamente('Notificaciones'),
            icon: const Badge(label: Text('2'), child: Icon(Icons.notifications_outlined)),
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: _cerrarSesion,
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(
        index: _tab,
        children: [
          _buildMesas(texto),
          const _Proximamente(
            icono: Icons.receipt_long,
            titulo: 'Mis órdenes',
            texto: 'Aquí verás tus órdenes activas y su estado en cocina.',
          ),
          _buildPerfil(texto),
        ],
      ),
      floatingActionButton: _tab == 0
          ? FloatingActionButton.extended(
              onPressed: () => _proximamente('Nueva orden'),
              icon: const Icon(Icons.add),
              label: const Text('Nueva orden'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.table_restaurant_outlined), selectedIcon: Icon(Icons.table_restaurant), label: 'Mesas'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'Órdenes'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _buildMesas(TextTheme texto) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      children: [
        Row(
          children: [
            StatCard(titulo: 'Libres', valor: _contar(EstadoMesa.libre), color: AppColors.libre, icono: Icons.check_circle_outline),
            const SizedBox(width: 10),
            StatCard(titulo: 'Ocupadas', valor: _contar(EstadoMesa.ocupada), color: AppColors.ocupada, icono: Icons.restaurant),
            const SizedBox(width: 10),
            StatCard(titulo: 'Por cobrar', valor: _contar(EstadoMesa.porCobrar), color: AppColors.porCobrar, icono: Icons.payments_outlined),
          ],
        ),
        const SizedBox(height: 24),
        Text('Mesas', style: texto.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ChoiceChip(
              label: const Text('Todas'),
              selected: _zona == null,
              onSelected: (_) => setState(() => _zona = null),
            ),
            for (final z in zonas)
              ChoiceChip(
                label: Text(z),
                selected: _zona == z,
                onSelected: (_) => setState(() => _zona = z),
              ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _mesasFiltradas.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 180,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.82,
          ),
          itemBuilder: (_, i) {
            final mesa = _mesasFiltradas[i];
            return MesaCard(mesa: mesa, onTap: () => _verMesa(mesa));
          },
        ),
      ],
    );
  }

  Widget _buildPerfil(TextTheme texto) {
    final u = widget.usuario;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 16),
        Center(
          child: CircleAvatar(
            radius: 44,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            child: Text(u.iniciales, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
          ),
        ),
        const SizedBox(height: 16),
        Text(u.nombre, textAlign: TextAlign.center, style: texto.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
        Text('@${u.usuario} · ${u.rol.etiqueta}',
            textAlign: TextAlign.center, style: texto.bodyMedium?.copyWith(color: AppColors.muted)),
        const SizedBox(height: 32),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
          onPressed: _cerrarSesion,
          icon: const Icon(Icons.logout),
          label: const Text('Cerrar sesión'),
        ),
      ],
    );
  }
}

class _Dato extends StatelessWidget {
  final IconData icono;
  final String texto;

  const _Dato({required this.icono, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icono, size: 20, color: AppColors.muted),
          const SizedBox(width: 10),
          Text(texto),
        ],
      ),
    );
  }
}

class _Proximamente extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String texto;

  const _Proximamente({required this.icono, required this.titulo, required this.texto});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 56, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(titulo, style: t.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(texto, textAlign: TextAlign.center, style: t.bodyMedium?.copyWith(color: AppColors.muted)),
            const SizedBox(height: 8),
            Text('Siguiente avance', style: t.labelMedium?.copyWith(color: AppColors.primary)),
          ],
        ),
      ),
    );
  }
}
