// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Noticia {
  int id;
  String titulo;
  String resumen;
  String imagenUrl;
  DateTime fecha;
  String fuente;
  String link;

  Noticia({
    required this.id,
    required this.titulo,
    required this.resumen,
    required this.imagenUrl,
    required this.fecha,
    required this.fuente,
    required this.link,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'titulo': titulo,
      'resumen': resumen,
      'imagenUrl': imagenUrl,
      'fecha': fecha.millisecondsSinceEpoch,
      'fuente': fuente,
      'link': link,
    };
  }

  factory Noticia.fromMap(Map<String, dynamic> map) {
    return Noticia(
      id: map['id'] as int,
      titulo: map['titulo'] as String,
      resumen: map['resumen'] as String,
      imagenUrl: map['imagenUrl'] as String,
      fecha: DateTime.parse(map['fecha'] as String),
      fuente: map['fuente'] as String,
      link: map['link'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Noticia.fromJson(String source) =>
      Noticia.fromMap(json.decode(source) as Map<String, dynamic>);
}
