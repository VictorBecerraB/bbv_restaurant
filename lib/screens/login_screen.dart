import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  final _auth = AuthService();

  bool _ocultarPin = true;
  bool _cargando = false;
  String? _error;

  @override
  void dispose() {
    _usuarioCtrl.dispose();
    _pinCtrl.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final usuario = await _auth.login(_usuarioCtrl.text, _pinCtrl.text);
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(
        HomeScreen.routeName,
        arguments: usuario,
      );
    } on AuthException catch (e) {
      setState(() => _error = e.mensaje);
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo
                    Center(
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withAlpha(70),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.restaurant_menu, color: Colors.white, size: 48),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Tacos Brothers',
                      textAlign: TextAlign.center,
                      style: texto.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.dark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'BBV Restaurant · Sistema de comandas',
                      textAlign: TextAlign.center,
                      style: texto.bodyMedium?.copyWith(color: AppColors.muted),
                    ),
                    const SizedBox(height: 40),

                    Text('Usuario', style: texto.labelLarge),
                    const SizedBox(height: 8),
                    TextFormField(
                      key: const Key('campo_usuario'),
                      controller: _usuarioCtrl,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Ej. luis',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Escribe tu usuario' : null,
                    ),
                    const SizedBox(height: 20),

                    Text('PIN', style: texto.labelLarge),
                    const SizedBox(height: 8),
                    TextFormField(
                      key: const Key('campo_pin'),
                      controller: _pinCtrl,
                      obscureText: _ocultarPin,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      onFieldSubmitted: (_) => _iniciarSesion(),
                      decoration: InputDecoration(
                        hintText: '4 a 6 dígitos',
                        counterText: '',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          tooltip: _ocultarPin ? 'Mostrar PIN' : 'Ocultar PIN',
                          icon: Icon(_ocultarPin ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                          onPressed: () => setState(() => _ocultarPin = !_ocultarPin),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Escribe tu PIN';
                        if (v.length < 4) return 'El PIN tiene al menos 4 dígitos';
                        if (int.tryParse(v) == null) return 'Solo números';
                        return null;
                      },
                    ),

                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE3E3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Color(0xFFC92A2A)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(_error!, style: const TextStyle(color: Color(0xFFC92A2A))),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 28),
                    FilledButton(
                      key: const Key('boton_login'),
                      onPressed: _cargando ? null : _iniciarSesion,
                      child: _cargando
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                            )
                          : const Text('Iniciar sesión'),
                    ),
                    const SizedBox(height: 24),

                    // Usuarios de prueba del avance 1
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Usuarios de prueba',
                              style: texto.labelLarge?.copyWith(color: AppColors.dark)),
                          const SizedBox(height: 6),
                          Text(
                            'luis / 1234 (mesero)\nana / 4321 (cajera)\nadmin / 0000 (gerente)',
                            style: texto.bodySmall?.copyWith(color: AppColors.muted, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
