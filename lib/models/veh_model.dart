class VehiculoModel {
  final int id;
  final String marca;
  final String modelo;
  final int anio;
  final String placa;
  //final String? imagen;

  VehiculoModel({
    required this.id,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.placa,
    //this.imagen,
  });

  factory VehiculoModel.fromJson(Map<String, dynamic> json) {
    return VehiculoModel(
      id: json['id'],
      marca: json['marca'],
      modelo: json['modelo'],
      anio: json['anio'],
      placa: json['placa'],
      //imagenUrl: json['imagen'], // viene del API
    );
  }
}
