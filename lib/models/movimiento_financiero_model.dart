import 'dart:convert';

class MovimientoFinanciero {
  final int? id;
  final int vehiculoId;
  final String? categoria;
  final String descripcion;
  final double monto;
  final String fecha;

  MovimientoFinanciero({
    this.id,
    required this.vehiculoId,
    this.categoria,
    required this.descripcion,
    required this.monto,
    required this.fecha,
  });

  factory MovimientoFinanciero.fromMap(Map<String, dynamic> map) {
    return MovimientoFinanciero(
      id: _toInt(map['id']),
      vehiculoId: _toInt(map['vehiculo_id'] ?? map['id_vehiculo']) ?? 0,
      categoria: _toNullableString(
        map['categoria'] ??
            map['categoria_nombre'] ??
            map['categoriaNombre'] ??
            map['tipo'],
      ),
      descripcion:
          (map['descripcion'] ??
                  map['detalle'] ??
                  map['concepto'] ??
                  map['titulo'] ??
                  'Sin descripcion')
              .toString(),
      monto: _toDouble(map['monto'] ?? map['valor'] ?? map['cantidad']) ?? 0,
      fecha: (map['fecha'] ?? map['created_at'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'vehiculo_id': vehiculoId,
      if (categoria != null) 'categoria': categoria,
      'descripcion': descripcion,
      'monto': monto,
      'fecha': fecha,
    };
  }

  String toJson() => json.encode(toMap());

  factory MovimientoFinanciero.fromJson(String source) =>
      MovimientoFinanciero.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static String? _toNullableString(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }
}
