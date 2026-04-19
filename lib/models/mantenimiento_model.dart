import 'dart:convert';

class Mantenimiento {
  final int? id;
  final int vehiculoId;
  final String tipo;
  final double costo;
  final String piezas;
  final String fecha;
  final List<String> fotos;

  Mantenimiento({
    this.id,
    required this.vehiculoId,
    required this.tipo,
    required this.costo,
    required this.piezas,
    required this.fecha,
    this.fotos = const [],
  });

  factory Mantenimiento.fromMap(Map<String, dynamic> map) {
    return Mantenimiento(
      id: map['id'] as int?,
      vehiculoId: map['vehiculo_id'] as int,
      tipo: map['tipo'] as String? ?? '',
      costo: double.parse(map['costo'].toString()),
      piezas: map['piezas'] as String? ?? '',
      fecha: map['fecha'] as String? ?? '',
      fotos: map['fotos'] != null
          ? List<String>.from(map['fotos'] as List)
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'vehiculo_id': vehiculoId,
      'tipo': tipo,
      'costo': costo,
      'piezas': piezas,
      'fecha': fecha,
      'fotos': fotos,
    };
  }

  String toJson() => json.encode(toMap());

  factory Mantenimiento.fromJson(String source) =>
      Mantenimiento.fromMap(json.decode(source) as Map<String, dynamic>);
}