import '../models/mesa.dart';

/// Datos de demostración para el avance 1.
/// En el siguiente avance se obtendrán de GET /api/v1/tables.
const List<String> zonas = ['Salón', 'Terraza', 'Barra'];

const List<Mesa> mesasDemo = [
  Mesa(numero: 1, zona: 'Salón', asientos: 4, estado: EstadoMesa.libre),
  Mesa(numero: 2, zona: 'Salón', asientos: 4, estado: EstadoMesa.ocupada, comensales: 3, minutos: 12, total: 186, mesero: 'Luis'),
  Mesa(numero: 3, zona: 'Salón', asientos: 2, estado: EstadoMesa.libre),
  Mesa(numero: 4, zona: 'Salón', asientos: 6, estado: EstadoMesa.porCobrar, comensales: 5, minutos: 48, total: 642, mesero: 'Luis'),
  Mesa(numero: 5, zona: 'Salón', asientos: 4, estado: EstadoMesa.ocupada, comensales: 2, minutos: 25, total: 101, mesero: 'Luis'),
  Mesa(numero: 6, zona: 'Salón', asientos: 4, estado: EstadoMesa.libre),
  Mesa(numero: 7, zona: 'Terraza', asientos: 4, estado: EstadoMesa.ocupada, comensales: 4, minutos: 8, total: 264, mesero: 'Carla'),
  Mesa(numero: 8, zona: 'Terraza', asientos: 2, estado: EstadoMesa.libre),
  Mesa(numero: 9, zona: 'Terraza', asientos: 6, estado: EstadoMesa.porCobrar, comensales: 6, minutos: 55, total: 918, mesero: 'Carla'),
  Mesa(numero: 10, zona: 'Barra', asientos: 1, estado: EstadoMesa.ocupada, comensales: 1, minutos: 5, total: 66, mesero: 'Luis'),
  Mesa(numero: 11, zona: 'Barra', asientos: 1, estado: EstadoMesa.libre),
  Mesa(numero: 12, zona: 'Barra', asientos: 1, estado: EstadoMesa.libre),
];
