import 'package:dio/dio.dart';
import 'package:xtreme_performance/models/veh_model.dart';
import 'package:xtreme_performance/utils/dio_client.dart';

class VehService {
  final DioClient _dio = DioClient();

  Future<List<VehiculoModel>> obtenerVehiculos() async {
    final response = await _dio.get("/api/vehiculos");

    return (response.data as List)
        .map((e) => VehiculoModel.fromJson(e))
        .toList();
  }
}
