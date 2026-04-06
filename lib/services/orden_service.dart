import 'package:dio/dio.dart';
import '../utils/dio_client.dart';

class OrdenService {
  /// Obtiene la información detallada de una orden de servicio.
  Future<Map<String, dynamic>?> obtenerOrden(String id) async {
    try {
      await DioClient.setTokenHeader();
      final response = await DioClient.dio.get('/orden-servicio/$id');
      return response.data;
    } catch (e) {
      print("Error al obtener detalle de la orden: $e");
      return null;
    }
  }

  /// Obtiene la lista de órdenes activas para un vehículo específico.
  Future<List<dynamic>> obtenerOrdenesActivas(int vehiculoId) async {
    try {
      await DioClient.setTokenHeader();
      final response = await DioClient.dio.get(
        '/vehiculos/$vehiculoId/ordenes-activas',
      );
      return response.data is List ? response.data : [];
    } catch (e) {
      print("Error al obtener órdenes activas: $e");
      return [];
    }
  }

  /// Aprueba el diagnóstico y mueve la orden a la etapa de reparación.
  Future<bool> validarDiagnostico(String id) async {
    try {
      await DioClient.setTokenHeader();
      final response = await DioClient.dio.post(
        '/etapa-servicio/validar-diagnostico/$id',
        data: {
          'estado': 'aprobado',
        }, // Cambiado para cumplir con la validación del backend
      );
      // Aceptamos cualquier código 2xx (200, 201, 204)
      return response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;
    } on DioException catch (e) {
      print("Error al validar diagnóstico: ${e.response?.data}");
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Cambia el estado de validación a 'aclaracion'.
  Future<bool> solicitarAclaracion(String id) async {
    try {
      await DioClient.setTokenHeader();
      final response = await DioClient.dio.post(
        '/etapa-servicio/validar-diagnostico/$id',
        data: {'estado': 'aclaracion'},
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      print("Error al solicitar aclaración: ${e.response?.data}");
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Cambia el estado general de la orden (ej. a 'pausado').
  Future<bool> cambiarEstadoOrden(String id, String estado) async {
    try {
      await DioClient.setTokenHeader();
      final response = await DioClient.dio.patch(
        '/ordenes-servicio/$id/estado',
        data: {'estado': estado},
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      print("Error al cambiar estado general: ${e.response?.data}");
      return false;
    } catch (e) {
      return false;
    }
  }
}
