import 'dart:convert';

class Combustible {
  int id;
  int vehiculoId;
  String tipo; // "combustible" o "aceite"
  double cantidad;
  String unidad; // "galones", "litros", "qt"
  double monto;
  String fecha;

  Combustible({
    required this.id,
    required this.vehiculoId,
    required this.tipo,
    required this.cantidad,
    required this.unidad,
    required this.monto,
    required this.fecha,
  });

  factory Combustible.fromMap(Map<String, dynamic> map) {
    return Combustible(
      id: map['id'] as int,
      vehiculoId: map['vehiculo_id'] as int,
      tipo: map['tipo'] as String,
      cantidad: double.parse(map['cantidad'].toString()),
      unidad: map['unidad'] as String,
      monto: double.parse(map['monto'].toString()),
      fecha: map['fecha'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vehiculo_id': vehiculoId,
      'tipo': tipo,
      'cantidad': cantidad,
      'unidad': unidad,
      'monto': monto,
      'fecha': fecha,
    };
  }

  String toJson() => json.encode(toMap());

  factory Combustible.fromJson(String source) =>
      Combustible.fromMap(json.decode(source) as Map<String, dynamic>);
}