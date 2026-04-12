

import 'package:car_api_final_app/models/noticia_model.dart';
import 'package:dio/dio.dart';
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
  static Future<List<Noticia>> getNoticia() async {
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
      print("Dio Error: ${e.message}");
    }
    return [];
  }
}
