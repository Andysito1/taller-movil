import 'package:dio/dio.dart';
import '../utils/dio_client.dart';
import '../models/historial_orden_model.dart';

class HistorialService {
  Future<List<HistorialOrdenModel>> obtenerHistorialPorVehiculo(
    int vehiculoId,
  ) async {
    try {
      await DioClient.setTokenHeader();
      final response = await DioClient.dio.get('/historial/$vehiculoId');

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data;
        return data.map((json) => HistorialOrdenModel.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      print("Error en HistorialService: ${e.response?.data}");
      return [];
    } catch (e) {
      print("Error inesperado en HistorialService: $e");
      return [];
    }
  }
}
