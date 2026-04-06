import 'package:dio/dio.dart';
import '../utils/dio_client.dart';
import '../models/etapa_model.dart';

class SeguimientoService {
  Future<Map<String, dynamic>> obtenerSeguimientoPorVehiculo(
    int vehiculoId,
  ) async {
    try {
      final response = await DioClient.dio.get('/seguimiento/$vehiculoId');

      // DEBUG: Imprimir respuesta para verificar datos
      print("Respuesta Seguimiento ($vehiculoId): ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        final dynamic responseData = response.data;

        // Si el backend responde con un mensaje de "no hay órdenes", manejamos el nulo
        if (responseData is Map && responseData['etapas'] == null) {
          return {'etapas': [], 'titulo': 'Sin servicio activo'};
        }

        if (responseData['etapas'] != null) {
          final List<dynamic> etapasRaw = responseData['etapas'];
          // Capturamos el ID de la orden desde la raíz del JSON, priorizando 'id_orden' o 'id'
          final dynamic rawOrdenId =
              responseData['id_orden'] ?? responseData['id'];
          final int ordenId = int.tryParse(rawOrdenId.toString()) ?? 0;

          print("DEBUG: ID de orden extraído del root: $ordenId");

          final String titulo =
              responseData['titulo'] ??
              responseData['nombre'] ??
              'Servicio Actual';

          final etapas = etapasRaw.map((e) {
            final Map<String, dynamic> etapaMap = Map<String, dynamic>.from(e);
            // Inyectamos el ID de la orden para que EtapaModel lo use en la navegación
            etapaMap['id_orden'] = ordenId;
            return EtapaModel.fromJson(etapaMap);
          }).toList();

          return {'etapas': etapas, 'titulo': titulo};
        }
      }
      return {'etapas': [], 'titulo': 'Sin servicio activo'};
    } on DioException catch (e) {
      // Si hay error o no hay orden activa, retornamos lista vacía o manejamos el error
      print(
        "Error Dio al obtener seguimiento: ${e.response?.statusCode} - ${e.response?.data}",
      );
      return {'etapas': [], 'titulo': 'Error al cargar'};
    } catch (e) {
      print("Error inesperado: $e");
      return {'etapas': [], 'titulo': 'Error inesperado'};
    }
  }
}
