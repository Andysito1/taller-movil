class EtapaModel {
  final int id;
  final String titulo;
  final String descripcion;
  final String estado; // "Pendiente", "En Progreso", "Completado"
  final String? fecha;
  final String tipo; // "DIAGNOSTICO", "REPARACION", "PRUEBAS", "FINALIZACION"

  EtapaModel({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.estado,
    this.fecha,
    required this.tipo,
  });

  factory EtapaModel.fromJson(Map<String, dynamic> json) {
    return EtapaModel(
      // Buscamos el ID de la orden. Asegúrate que el JSON de seguimiento incluya este campo.
      id: json['id'] ?? json['orden_id'] ?? json['id_orden'] ?? 0,
      titulo: json['titulo'] ?? '',
      descripcion: json['descripcion'] ?? '',
      estado: json['estado'] ?? 'Pendiente',
      fecha: json['fecha'],
      tipo: json['tipo'] ?? 'GENERICO',
    );
  }
}
