import 'package:car_api_final_app/models/care_video_model.dart';
import 'package:car_api_final_app/models/gasto_categoria_model.dart';
import 'package:car_api_final_app/models/goma_model.dart';
import 'package:car_api_final_app/models/noticia_model.dart';
import 'package:car_api_final_app/models/mantenimiento_model.dart';
import 'package:car_api_final_app/models/movimiento_financiero_model.dart';
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

  static Map<String, String> _authHeaders(String? token) {
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static List<dynamic> _extractItems(dynamic data) {
    if (data is List) return data;
    if (data is! Map<String, dynamic>) return [];

    final direct = data['data'];
    if (direct is List) return direct;

    if (direct is Map<String, dynamic>) {
      final nested =
          direct['data'] ?? direct['items'] ?? direct['rows'] ?? direct['results'];
      if (nested is List) return nested;
    }

    final fallback = data['items'] ?? data['rows'] ?? data['results'];
    return fallback is List ? fallback : [];
  }

  static bool _extractHasMore(dynamic data, int currentPage, int fetchedCount) {
    if (data is! Map<String, dynamic>) return fetchedCount > 0;

    final page = _toInt(data['page']) ?? currentPage;
    final limit = _toInt(data['limit']);
    final total = _toInt(data['total']);

    if (limit != null && total != null) {
      return page * limit < total;
    }

    Map<String, dynamic>? pagination;
    final direct = data['data'];

    if (data['pagination'] is Map<String, dynamic>) {
      pagination = data['pagination'] as Map<String, dynamic>;
    } else if (data['meta'] is Map<String, dynamic>) {
      pagination = data['meta'] as Map<String, dynamic>;
    } else if (direct is Map<String, dynamic>) {
      if (direct['pagination'] is Map<String, dynamic>) {
        pagination = direct['pagination'] as Map<String, dynamic>;
      } else if (direct['meta'] is Map<String, dynamic>) {
        pagination = direct['meta'] as Map<String, dynamic>;
      }
    }

    if (pagination != null) {
      final hasMore = pagination['has_more'] ?? pagination['hasMore'];
      if (hasMore is bool) return hasMore;

      final current =
          _toInt(pagination['current_page'] ?? pagination['page']) ?? currentPage;
      final last = _toInt(pagination['last_page'] ?? pagination['total_pages']);
      final nextPageUrl = pagination['next_page_url'];

      if (nextPageUrl != null && nextPageUrl.toString().isNotEmpty) return true;
      if (last != null) return current < last;
    }

    return fetchedCount >= 20;
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('TOKEN');
  }

  //Consigue la lista de noticias actuales
  static Future<List<Noticia>> getListaNoticias() async {
    try {
      final res = await _dio.get(
        '/publico/noticias',
        options: Options(headers: {'Accept': 'application/json'}),
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
          headers: _authHeaders(token),
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
          headers: _authHeaders(token),
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
          headers: _authHeaders(token),
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
          headers: _authHeaders(token),
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
    try {
      final res = await _dio.get(
        '/publico/foro',
        queryParameters: {'page': page, 'limit': 50},
      );
      if (res.data['success'] == true) return res.data;
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
    }
    return {};
  }

  // Detalle de tema con respuestas
  static Future<Map<String, dynamic>?> getDetalleTema(int id) async {
    try {
      final res = await _dio.get(
        '/publico/foro/detalle',
        queryParameters: {'id': id},
        options: Options(headers: {'Accept': 'application/json'}),
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
          headers: _authHeaders(token),
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
        options: Options(headers: _authHeaders(token)),
      );
      if (res.data['success'] == true) return res.data;
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
    }
    return {};
  }

  static Future<List<CareVideo>> getVideos() async {
    try {
      final res = await _dio.get(
        '/publico/videos',
        options: Options(headers: {'Acccept': 'application/json'}),
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
          headers: _authHeaders(token),
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
          headers: _authHeaders(token),
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
        options: Options(headers: _authHeaders(token)),
      );
      return res.data['success'] == true;
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
    }
    return false;
  }

  static Future<List<Goma>> getListaGomas(int vehiculoId) async {
    final token = await getToken();
    try {
      final res = await _dio.get(
        '/gomas',
        queryParameters: {'vehiculo_id': vehiculoId},
        options: Options(headers: _authHeaders(token)),
      );

      if (res.data['success'] == true) {
        final data = res.data['data'];
        final items = data is Map<String, dynamic>
            ? (data['gomas'] as List<dynamic>? ?? const [])
            : const [];
        return items
            .whereType<Map>()
            .map((item) => Goma.fromMap(Map<String, dynamic>.from(item)))
            .toList();
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
    }
    return [];
  }

  static Future<bool> actualizarEstadoGoma({
    required int gomaId,
    required String estado,
  }) async {
    final token = await getToken();
    try {
      final res = await _dio.post(
        '/gomas/actualizar',
        data: {
          'datax': json.encode({
            'goma_id': gomaId,
            'estado': estado,
          }),
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: _authHeaders(token),
        ),
      );
      return res.data['success'] == true;
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
    }
    return false;
  }

  static Future<bool> registrarPinchazoGoma({
    required int gomaId,
    required String descripcion,
    required String fecha,
  }) async {
    final token = await getToken();
    try {
      final res = await _dio.post(
        '/gomas/pinchazos',
        data: {
          'datax': json.encode({
            'goma_id': gomaId,
            'descripcion': descripcion,
            'fecha': fecha,
          }),
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: _authHeaders(token),
        ),
      );
      return res.data['success'] == true;
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
    }
    return false;
  }

  static Future<List<GastoCategoria>> getCategoriasGastos() async {
    final token = await getToken();
    try {
      final res = await _dio.get(
        '/gastos/categorias',
        options: Options(headers: _authHeaders(token)),
      );

      if (res.data['success'] == true) {
        final items = _extractItems(res.data);
        return items.map(GastoCategoria.fromDynamic).toList();
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
    }
    return [];
  }

  static Future<Map<String, dynamic>> getListaGastos(
    int vehiculoId, {
    int page = 1,
  }) async {
    final token = await getToken();
    try {
      final res = await _dio.get(
        '/gastos',
        queryParameters: {
          'vehiculo_id': vehiculoId,
          'page': page,
          'limit': 20,
        },
        options: Options(headers: _authHeaders(token)),
      );

      if (res.data['success'] == true) {
        final items = _extractItems(res.data)
            .whereType<Map>()
            .map(
              (item) => MovimientoFinanciero.fromMap(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList();

        return {
          'items': items,
          'hasMore': _extractHasMore(res.data, page, items.length),
        };
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
    }
    return {'items': <MovimientoFinanciero>[], 'hasMore': false};
  }

  static Future<bool> registrarGasto({
    required int vehiculoId,
    required String categoria,
    required String descripcion,
    required double monto,
  }) async {
    final token = await getToken();
    try {
      final categoriaId = int.tryParse(categoria);
      final res = await _dio.post(
        '/gastos',
        data: {
          'datax': json.encode({
            'vehiculo_id': vehiculoId,
            'categoriaId': categoriaId ?? categoria,
            'descripcion': descripcion,
            'monto': monto,
          }),
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: _authHeaders(token),
        ),
      );
      return res.data['success'] == true;
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
    }
    return false;
  }

  static Future<Map<String, dynamic>> getListaIngresos(
    int vehiculoId, {
    int page = 1,
  }) async {
    final token = await getToken();
    try {
      final res = await _dio.get(
        '/ingresos',
        queryParameters: {
          'vehiculo_id': vehiculoId,
          'page': page,
          'limit': 20,
        },
        options: Options(headers: _authHeaders(token)),
      );

      if (res.data['success'] == true) {
        final items = _extractItems(res.data)
            .whereType<Map>()
            .map(
              (item) => MovimientoFinanciero.fromMap(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList();

        return {
          'items': items,
          'hasMore': _extractHasMore(res.data, page, items.length),
        };
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
    }
    return {'items': <MovimientoFinanciero>[], 'hasMore': false};
  }

  static Future<bool> registrarIngreso({
    required int vehiculoId,
    required String concepto,
    required double monto,
  }) async {
    final token = await getToken();
    try {
      final res = await _dio.post(
        '/ingresos',
        data: {
          'datax': json.encode({
            'vehiculo_id': vehiculoId,
            'concepto': concepto,
            'monto': monto,
          }),
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: _authHeaders(token),
        ),
      );
      return res.data['success'] == true;
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
    }
    return false;
  }
}
