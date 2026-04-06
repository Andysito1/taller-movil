class FinanzaModel {
  final int id;
  final int idOrden;
  final String concepto;
  final String tipo; // 'base' o 'adicional'
  final double monto;

  FinanzaModel({
    required this.id,
    required this.idOrden,
    required this.concepto,
    required this.tipo,
    required this.monto,
  });

  factory FinanzaModel.fromJson(Map<String, dynamic> json) {
    return FinanzaModel(
      id: json['id'] ?? 0,
      // Soporte para id_orden o idOrden
      idOrden: json['id_orden'] ?? json['idOrden'] ?? 0,
      // Soporte para 'concepto' o 'Concepto' (como pusiste en tu ejemplo)
      concepto: json['concepto'] ?? json['Concepto'] ?? '',
      tipo: json['tipo'] ?? 'base',
      monto: json['monto'] != null
          ? double.tryParse(json['monto'].toString()) ?? 0.0
          : 0.0,
    );
  }
}
