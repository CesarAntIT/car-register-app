import 'dart:convert';

import 'package:car_api_final_app/models/pinchazo_model.dart';

class Goma {
  final int id;
  final int vehiculoId;
  final String posicion;
  final String eje;
  final String estado;
  final int totalPinchazos;
  final List<Pinchazo> pinchazos;

  Goma({
    required this.id,
    required this.vehiculoId,
    required this.posicion,
    required this.eje,
    required this.estado,
    required this.totalPinchazos,
    this.pinchazos = const [],
  });

  factory Goma.fromMap(Map<String, dynamic> map) {
    final pinchazosRaw =
        map['pinchazos'] ?? map['historial_pinchazos'] ?? const [];
    final pinchazos = pinchazosRaw is List
        ? pinchazosRaw
              .whereType<Map>()
              .map(
                (item) =>
                    Pinchazo.fromMap(Map<String, dynamic>.from(item)),
              )
              .toList()
        : <Pinchazo>[];

    return Goma(
      id: _toInt(map['id'] ?? map['goma_id'] ?? map['id_goma']) ?? 0,
      vehiculoId: _toInt(map['vehiculo_id'] ?? map['id_vehiculo']) ?? 0,
      posicion: (map['posicion'] ?? map['nombre'] ?? 'Sin posicion').toString(),
      eje: (map['eje'] ?? '').toString(),
      estado: (map['estado'] ?? 'buena').toString(),
      totalPinchazos:
          _toInt(map['totalPinchazos'] ?? map['total_pinchazos']) ??
          pinchazos.length,
      pinchazos: pinchazos,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vehiculo_id': vehiculoId,
      'posicion': posicion,
      'eje': eje,
      'estado': estado,
      'totalPinchazos': totalPinchazos,
      'pinchazos': pinchazos.map((item) => item.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  factory Goma.fromJson(String source) =>
      Goma.fromMap(json.decode(source) as Map<String, dynamic>);

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}
