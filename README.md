# BBV Restaurant · Tacos Brothers

App móvil en **Flutter** para tomar y administrar las órdenes de la taquería **Tacos Brothers**. Los meseros toman la orden en el celular y esta se envía por una **API REST** a la **computadora central** del restaurante, donde la ven cocina y caja.

> Avance 1 del proyecto ordinario: login y pantalla inicial (mapa de mesas) funcionando, mockups de todas las pantallas y documento de propuesta.

## Pantallas del avance 1

| Pantalla | Estado |
| --- | --- |
| Inicio de sesión (usuario + PIN, validaciones, mensaje de error) | ✅ Implementada |
| Inicio: mapa de mesas con resumen (libres, ocupadas, por cobrar), filtro por zona y detalle de mesa | ✅ Implementada |
| Tomar orden (menú), resumen y envío a cocina | 🕒 Siguiente avance |
| Pantalla de cocina (KDS) y caja | 🕒 Siguiente avance |

Los mockups están en [`docs/mockups`](docs/mockups) y la propuesta completa en [`docs/Propuesta_BBV_Restaurant.pdf`](docs/Propuesta_BBV_Restaurant.pdf).

## Usuarios de prueba

| Usuario | PIN | Rol |
| --- | --- | --- |
| luis | 1234 | Mesero |
| ana | 4321 | Cajera |
| admin | 0000 | Gerente |

En este avance el login valida contra usuarios de demostración (`lib/services/auth_service.dart`). En el siguiente avance se conecta a `POST /api/v1/auth/login`.

## Cómo ejecutarla

Requisitos: Flutter 3.10 o superior.

```bash
git clone <url-del-repositorio>
cd bbv_restaurant
flutter create .        # genera las carpetas de plataforma si faltan
flutter pub get
flutter run             # elige Windows, Chrome o un emulador Android
```

Pruebas:

```bash
flutter test
```

## Estructura

```
lib/
├── main.dart                 # rutas: /login y /home
├── theme/app_theme.dart      # colores y tema de Tacos Brothers
├── models/                   # Usuario (roles) y Mesa (estados)
├── data/datos_demo.dart      # mesas de demostración
├── services/auth_service.dart
├── screens/
│   ├── login_screen.dart
│   └── home_screen.dart
└── widgets/                  # MesaCard, StatCard
docs/
├── mockups/                  # PNG de las 6 pantallas
└── Propuesta_BBV_Restaurant.pdf
```

## Arquitectura (resumen)

- **App móvil:** Flutter 3 + Dart.
- **API:** Node.js + NestJS, REST + WebSockets (Socket.IO), JWT.
- **Base de datos:** PostgreSQL 16.
- **Sistema central (cocina y caja):** Flutter Desktop para Windows.

Equipo: Víctor Becerra Benavides.
