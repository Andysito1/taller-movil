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
    // Función auxiliar para parsear ID de forma segura
    int parseId(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      return int.tryParse(value.toString()) ?? 0;
    }

    return EtapaModel(
      // Priorizamos id_orden (inyectado por el servicio) o orden_id (del backend)
      id: parseId(json['id_orden'] ?? json['orden_id']),
      titulo: json['titulo'] ?? '',
      descripcion: json['descripcion'] ?? '',
      estado: json['estado'] ?? 'Pendiente',
      fecha: json['fecha'],
      tipo: json['tipo'] ?? 'GENERICO',
    );
  }
}
