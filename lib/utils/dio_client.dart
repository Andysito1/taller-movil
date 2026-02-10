import 'package:dio/dio.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://digi-api.com/api/v1' // Aqui va la ruta
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<dynamic> get(String s) async {}
}