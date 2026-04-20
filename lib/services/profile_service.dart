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
}
