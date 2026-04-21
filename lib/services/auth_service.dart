import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "https://taller-itla.ia3x.com/api";

  // LOGIN
  static Future<Map<String, dynamic>?> login(
    String matricula,
    String contrasena,
  ) async {
    final url = Uri.parse("$baseUrl/auth/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "datax": jsonEncode({"matricula": matricula, "contrasena": contrasena}),
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> registro(String matricula) async {
    final url = Uri.parse("$baseUrl/auth/registro");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "datax": jsonEncode({"matricula": matricula}),
      },
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  static Future<bool> activar(String token, String contrasena) async {
    final url = Uri.parse("$baseUrl/auth/activar");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "datax": jsonEncode({"token": token.trim(), "contrasena": contrasena}),
      },
    );

    return response.statusCode == 200;
  }

  static Future<bool> cambiarClave(String actual, String nueva) async {
    final url = Uri.parse('$baseUrl/auth/cambiar-clave');

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('TOKEN');

      // Construimos el JSON interno
      final Map<String, String> dataxMap = {"actual": actual, "nueva": nueva};

      // La API espera el campo 'datax' con el JSON como string
      final response = await http.post(
        url,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'datax': jsonEncode(dataxMap)},
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        return decodedResponse['success'] ?? false;
      } else {
        print('Error en petición: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Excepción al cambiar clave: $e');
      return false;
    }
  }

  // RECUPERAR CONTRASEÑA
  static Future<bool> recuperarClave(String matricula) async {
    final url = Uri.parse("$baseUrl/auth/olvidar");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "datax": jsonEncode({"matricula": matricula}),
      },
    );

    print(response.body);

    return response.statusCode == 200;
  }
}