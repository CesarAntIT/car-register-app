import 'dart:convert';
import 'dart:io';
import 'package:car_api_final_app/models/vehiculo_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VehiculoService {
  final _dio = Dio(BaseOptions(baseUrl: "https://taller-itla.ia3x.com/api"));

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('TOKEN');
  }

  Future<List<Vehiculo>> getVehiculos() async {
    final token = await _getToken();
    try {
      final res = await _dio.get(
        '/vehiculos',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (res.data['success'] == true) {
        final List<dynamic> data = res.data['data'];
        return data
            .map((v) => Vehiculo.fromJson(v as Map<String, dynamic>))
            .toList();
      }
    } on DioException catch (e) {
      print("Error: ${e.message}");
    }
    return [];
  }

  Future<bool> createVehiculo(Vehiculo vehiculo, {File? foto}) async {
    final token = await _getToken();
    try {
      // Para CREAR, la API sí acepta cantidadRuedas y foto en un solo multipart
      Map<String, dynamic> dataMap = {
        'placa': vehiculo.placa,
        'chasis': vehiculo.chasis,
        'marca': vehiculo.marca,
        'modelo': vehiculo.modelo,
        'anio': vehiculo.anio,
        'cantidadRuedas': vehiculo.cantidadRuedas, // Se envía como número
      };

      FormData formData = FormData.fromMap({'datax': jsonEncode(dataMap)});

      if (foto != null) {
        formData.files.add(
          MapEntry(
            'foto',
            await MultipartFile.fromFile(foto.path, filename: 'vehiculo.jpg'),
          ),
        );
      }

      final res = await _dio.post(
        '/vehiculos',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return res.data['success'] == true;
    } catch (e) {
      print("Error creando: $e");
      return false;
    }
  }

  Future<bool> updateVehiculo(int id, Vehiculo vehiculo, {File? foto}) async {
    final token = await _getToken();
    try {
      // 1. EDITAR DATOS (Ruta: /vehiculos/editar)
      // Nota: Esta ruta no acepta cantidadRuedas según tu Swagger
      Map<String, dynamic> editMap = {
        'id': id,
        'placa': vehiculo.placa,
        'chasis': vehiculo.chasis,
        'marca': vehiculo.marca,
        'modelo': vehiculo.modelo,
        'anio': vehiculo.anio,
      };

      final resInfo = await _dio.post(
        '/vehiculos/editar',
        data: {'datax': jsonEncode(editMap)},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      // 2. EDITAR FOTO (Si el usuario seleccionó una nueva)
      if (foto != null) {
        FormData photoData = FormData.fromMap({
          'datax': jsonEncode({'id': id}),
          'foto': await MultipartFile.fromFile(
            foto.path,
            filename: 'update.jpg',
          ),
        });

        await _dio.post(
          '/vehiculos/foto',
          data: photoData,
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
      }

      return resInfo.data['success'] == true;
    } catch (e) {
      print("Error editando: $e");
      return false;
    }
  }
}
