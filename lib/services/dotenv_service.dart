import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DotenvService {
  static void SaveAuth() async {
    if (!dotenv.isInitialized) {
      await dotenv.load();
    }

    final prefs = await SharedPreferences.getInstance();
    final token = dotenv.env['AUTH_TOKEN'] ?? "";
    await prefs.setString('TOKEN', token);
  }
}
