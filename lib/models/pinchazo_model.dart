import 'dart:convert';

class Pinchazo {
  final int? id;
  final String descripcion;
  final String fecha;

  Pinchazo({this.id, required this.descripcion, required this.fecha});

  factory Pinchazo.fromMap(Map<String, dynamic> map) {
    return Pinchazo(
      id: _toInt(map['id'] ?? map['pinchazo_id']),
      descripcion:
          (map['descripcion'] ?? map['detalle'] ?? map['comentario'] ?? '')
              .toString(),
      fecha: (map['fecha'] ?? map['created_at'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'descripcion': descripcion,
      'fecha': fecha,
    };
  }

  String toJson() => json.encode(toMap());

  factory Pinchazo.fromJson(String source) =>
      Pinchazo.fromMap(json.decode(source) as Map<String, dynamic>);

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}
