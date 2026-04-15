// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CareVideo {
  int id;
  String youtubeId;
  String titulo;
  String descripcion;
  String categoria;
  String url;
  String thumbnail;

  CareVideo({
    required this.id,
    required this.youtubeId,
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    required this.url,
    required this.thumbnail,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'youtubeId': youtubeId,
      'titulo': titulo,
      'descripcion': descripcion,
      'categoria': categoria,
      'url': url,
      'thumbnail': thumbnail,
    };
  }

  factory CareVideo.fromMap(Map<String, dynamic> map) {
    return CareVideo(
      id: map['id'] as int,
      youtubeId: map['youtubeId'] as String,
      titulo: map['titulo'] as String,
      descripcion: map['descripcion'] as String,
      categoria: map['categoria'] as String,
      url: map['url'] as String,
      thumbnail: map['thumbnail'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CareVideo.fromJson(String source) =>
      CareVideo.fromMap(json.decode(source) as Map<String, dynamic>);
}
