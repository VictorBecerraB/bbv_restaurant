/// Roles del sistema (tabla `users`, columna `role`).
enum Rol { mesero, cocinero, cajero, gerente }

extension RolEtiqueta on Rol {
  String get etiqueta {
    switch (this) {
      case Rol.mesero:
        return 'Mesero';
      case Rol.cocinero:
        return 'Cocinero';
      case Rol.cajero:
        return 'Cajero';
      case Rol.gerente:
        return 'Gerente';
    }
  }
}

class Usuario {
  final int id;
  final String nombre;
  final String usuario;
  final Rol rol;

  const Usuario({
    required this.id,
    required this.nombre,
    required this.usuario,
    required this.rol,
  });

  String get iniciales {
    final partes = nombre.trim().split(' ');
    if (partes.length == 1) return partes.first.substring(0, 1).toUpperCase();
    return (partes[0].substring(0, 1) + partes[1].substring(0, 1)).toUpperCase();
  }

  /// Respuesta esperada de POST /api/v1/auth/login -> { user: {...} }
  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json['id'] as int,
        nombre: json['name'] as String,
        usuario: json['username'] as String,
        rol: Rol.values.byName(json['role'] as String),
      );
}
