import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static Future<Map<String, dynamic>?> getProfile(String token) async {
    final url = Uri.parse("https://taller-itla.ia3x.com/api/perfil");

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final currentToken = prefs.getString('TOKEN');
    if (currentToken != null) {
      await prefs.setString('TOKEN', "");
    }
  }

  static Future<String?> actualizarFotoPerfil(String filePath) async {
    final url = Uri.parse('https://taller-itla.ia3x.com/api/perfil/foto');

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('TOKEN');

      // 1. Creamos la petición Multipart
      var request = http.MultipartRequest('POST', url);

      request.headers.addAll({
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      request.files.add(await http.MultipartFile.fromPath('foto', filePath));

      // 4. Enviamos la petición
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        if (decodedData['success'] == true) {
          return decodedData['data']['fotoUrl'];
        }
      }

      print('Error al subir imagen: ${response.body}');
      return null;
    } catch (e) {
      print('Excepción en subir foto: $e');
      return null;
    }
  }
}