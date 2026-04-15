import 'package:car_api_final_app/models/care_video_model.dart';
import 'package:car_api_final_app/models/noticia_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
}
