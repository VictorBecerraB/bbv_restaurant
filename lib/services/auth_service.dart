import '../models/usuario.dart';

class AuthException implements Exception {
  final String mensaje;
  const AuthException(this.mensaje);

  @override
  String toString() => mensaje;
}

/// Servicio de autenticación.
///
/// Avance 1: valida contra usuarios de demostración para poder probar la app
/// sin servidor. En el avance 2 se reemplaza por la llamada real:
///   POST /api/v1/auth/login  { "username": "...", "pin": "..." }
///   -> 200 { "token": "<JWT>", "refreshToken": "...", "user": {...} }
class AuthService {
  static const Map<String, ({String pin, Usuario usuario})> _usuariosDemo = {
    'luis': (
      pin: '1234',
      usuario: Usuario(id: 3, nombre: 'Luis Hernández', usuario: 'luis', rol: Rol.mesero),
    ),
    'ana': (
      pin: '4321',
      usuario: Usuario(id: 4, nombre: 'Ana Ramírez', usuario: 'ana', rol: Rol.cajero),
    ),
    'admin': (
      pin: '0000',
      usuario: Usuario(id: 1, nombre: 'Víctor Becerra', usuario: 'admin', rol: Rol.gerente),
    ),
  };

  Future<Usuario> login(String usuario, String pin) async {
    // Simula la latencia de red de la API.
    await Future<void>.delayed(const Duration(milliseconds: 700));

    final entrada = _usuariosDemo[usuario.trim().toLowerCase()];
    if (entrada == null || entrada.pin != pin) {
      throw const AuthException('Usuario o PIN incorrectos');
    }
    return entrada.usuario;
  }
}
