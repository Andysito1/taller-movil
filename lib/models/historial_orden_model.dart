class HistorialOrdenModel {
  final int id;
  final String titulo;
  final String? fechaFin;
  final double costoTotal;
  final String estado;

  HistorialOrdenModel({
    required this.id,
    required this.titulo,
    this.fechaFin,
    required this.costoTotal,
    required this.estado,
  });

  factory HistorialOrdenModel.fromJson(Map<String, dynamic> json) {
    return HistorialOrdenModel(
      id: json['id'] ?? 0,
      // Solo tomamos 'titulo' o 'Titulo'. Si no existe, indicamos que no tiene título.
      titulo: json['titulo'] ?? json['Titulo'] ?? 'Orden #${json['id']}',
      // Mapeamos 'fecha_fin' (snake_case) a 'fechaFin'
      fechaFin: json['fecha_fin'],
      // Convertimos el string/decimal de la DB a double de forma segura
      costoTotal: json['costo_total'] != null
          ? double.tryParse(json['costo_total'].toString()) ?? 0.0
          : (json['total'] != null
                ? double.tryParse(json['total'].toString()) ?? 0.0
                : 0.0),
      estado: json['estado'] ?? '',
    );
  }
}
