import 'dart:convert';
import 'package:http/http.dart' as http;

class VehiculoService {
  static const String baseUrl = "https://taller-itla.ia3x.com/api";

  static Future<Map<String, dynamic>?> getDetalle(
      String token, int vehiculoId) async {
    final url = Uri.parse("$baseUrl/vehiculos/detalle?id=$vehiculoId");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.body);
      return null;
    }
  }
}