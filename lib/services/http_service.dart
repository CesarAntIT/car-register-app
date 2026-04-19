import 'package:car_api_final_app/models/care_video_model.dart';
import 'package:car_api_final_app/models/noticia_model.dart';
import 'package:car_api_final_app/models/mantenimiento_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:car_api_final_app/models/combustible_model.dart';

class HttpService {
  //TODO: Add all of the Functions to use the API
  static final _dio = Dio(
    BaseOptions(baseUrl: "https://taller-itla.ia3x.com/api"),
  );

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('TOKEN');
  }

  //Consigue la lista de noticias actuales
  static Future<List<Noticia>> getListaNoticias() async {
    final token = await getToken();

    try {
      final res = await _dio.get(
        '/noticias',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      //Only converts API data if it is true
      if (res.data['success'] == true) {
        final List<dynamic> data = res.data['data'];
        return data
            .map((item) => Noticia.fromMap(item as Map<String, dynamic>))
            .toList();
      }
    } on DioException catch (e) {
      debugPrint("Dio Error: ${e.message}");
    }
    return [];
  }

  static Future<Noticia?> getNoticia(int id) async {
    final token = await getToken();
    try {
      final res = await _dio.get(
        '/noticias/detalle',
        queryParameters: {'id': '$id'},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (res.data['success'] == true) {
        final dynamic resData = res.data['data'];
        return Noticia.fromMap(resData as Map<String, dynamic>);
      }
    } on DioException catch (e) {
      debugPrint("Dio Error: ${e.message}");
    }
    return null;
  }

  // Lista de registros de combustible/aceite
  static Future<List<Combustible>> getListaCombustibles(
    int vehiculoId, {
    String? tipo,
  }) async {
    final token = await getToken();
    try {
      final res = await _dio.get(
        '/combustibles',
        queryParameters: {
          'vehiculo_id': vehiculoId,
          if (tipo != null) 'tipo': tipo,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (res.data['success'] == true) {
        final List<dynamic> data = res.data['data'];
        return data
            .map((item) => Combustible.fromMap(item as Map<String, dynamic>))
            .toList();
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
    }
    return [];
  }

  // Registrar carga de combustible o aceite
  static Future<bool> registrarCombustible({
    required int vehiculoId,
    required String tipo,
    required double cantidad,
    required String unidad,
    required double monto,
  }) async {
    final token = await getToken();
    try {
      final res = await _dio.post(
        '/combustibles',
        data: {
          'datax': json.encode({
            'vehiculo_id': vehiculoId,
            'tipo': tipo,
            'cantidad': cantidad,
            'unidad': unidad,
            'monto': monto,
          }),
        },
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      return res.data['success'] == true;
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
    }
    return false;
  }

  // Crear tema en el foro
  static Future<bool> crearTemaForo({
    required int vehiculoId,
    required String titulo,
    required String descripcion,
  }) async {
    final token = await getToken();
    try {
      final res = await _dio.post(
        '/foro/crear',
        data: {
          'datax': json.encode({
            'vehiculo_id': vehiculoId,
            'titulo': titulo,
            'descripcion': descripcion,
          }),
        },
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      return res.data['success'] == true;
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
    }
    return false;
  }

  // Lista de temas del foro
  static Future<Map<String, dynamic>> getListaTemasForo({int page = 1}) async {
    final token = await getToken();
    try {
      final res = await _dio.get(
        '/foro/temas',
        queryParameters: {'page': page, 'limit': 20},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      if (res.data['success'] == true) return res.data;
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
    }
    return {};
  }

  // Detalle de tema con respuestas
  static Future<Map<String, dynamic>?> getDetalleTema(int id) async {
    final token = await getToken();
    try {
      final res = await _dio.get(
        '/foro/detalle',
        queryParameters: {'id': id},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      if (res.data['success'] == true) return res.data['data'];
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
    }
    return null;
  }

  // Responder tema
  static Future<bool> responderTema({
    required int temaId,
    required String contenido,
  }) async {
    final token = await getToken();
    try {
      final res = await _dio.post(
        '/foro/responder',
        data: {
          'datax': json.encode({'tema_id': temaId, 'contenido': contenido}),
        },
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      return res.data['success'] == true;
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
    }
    return false;
  }

  // Mis temas
  static Future<Map<String, dynamic>> getMisTemas() async {
    final token = await getToken();
    try {
      final res = await _dio.get(
        '/foro/mis-temas',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      if (res.data['success'] == true) return res.data;
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
    }
    return {};
  }

  static Future<List<CareVideo>> getVideos() async {
    final token = await getToken();
    try {
      final res = await _dio.get(
        '/videos',
        options: Options(
          headers: {
            'Acccept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (res.data['success'] == true) {
        final List<dynamic> data = res.data['data'];
        return data
            .map((item) => CareVideo.fromMap(item as Map<String, dynamic>))
            .toList();
      }
    } on DioException catch (e) {
      debugPrint(e.error.toString());
    }
    return [];
  }

  // Lista de mantenimientos de un vehículo
  static Future<List<Mantenimiento>> getListaMantenimientos(
    int vehiculoId, {
    String? tipo,
  }) async {
    final token = await getToken();
    try {
      final res = await _dio.get(
        '/mantenimientos',
        queryParameters: {
          'vehiculo_id': vehiculoId,
          if (tipo != null) 'tipo': tipo,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      if (res.data['success'] == true) {
        final List<dynamic> data = res.data['data'];
        return data
            .map((item) => Mantenimiento.fromMap(item as Map<String, dynamic>))
            .toList();
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
    }
    return [];
  }

  // Registrar un mantenimiento
  static Future<int?> registrarMantenimiento({
    required int vehiculoId,
    required String tipo,
    required double costo,
    required String piezas,
    required String fecha,
  }) async {
    final token = await getToken();
    try {
      final res = await _dio.post(
        '/mantenimientos',
        data: {
          'datax': json.encode({
            'vehiculo_id': vehiculoId,
            'tipo': tipo,
            'costo': costo,
            'piezas': piezas,
            'fecha': fecha,
            'fotos': [],
          }),
        },
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      if (res.data['success'] == true) {
        return res.data['data']['id'] as int?;
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
    }
    return null;
  }

  // Subir fotos (max 5)
  static Future<bool> subirFotosMantenimiento({
    required int mantenimientoId,
    required List<String> rutasFotos,
  }) async {
    final token = await getToken();
    try {
      final formData = FormData.fromMap({
        'datax': json.encode({'mantenimiento_id': mantenimientoId}),
        'fotos[]': await Future.wait(
          rutasFotos.map(
            (path) async => await MultipartFile.fromFile(
              path,
              filename: path.split('/').last,
            ),
          ),
        ),
      });
      final res = await _dio.post(
        '/mantenimientos/fotos',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      return res.data['success'] == true;
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
    }
    return false;
  }
}
