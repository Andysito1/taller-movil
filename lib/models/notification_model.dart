import 'package:flutter/material.dart';

class NotificationModel {
  final int id;
  final String type;
  final String title;
  final String mensaje;
  final DateTime timestamp;
  bool isRead; // Mutable para actualizar en UI

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.mensaje,
    required this.timestamp,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      // Mapeo desde Laravel (tipo, titulo, mensaje, leido)
      type: json['tipo'] ?? 'sistema',
      title: json['titulo'] ?? 'Sin Título',
      mensaje: json['mensaje'] ?? 'Sin Descripción',
      timestamp: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      isRead:
          json['leido'] == 1 || json['leido'] == true || json['leido'] == '1',
    );
  }

  Color get iconBackgroundColor {
    switch (type) {
      case 'servicio':
        return Colors.blue.shade50;
      case 'finanzas':
        return Colors.green.shade50;
      case 'sistema':
        return Colors.grey.shade200;
      default:
        return Colors.blue.shade50;
    }
  }

  Color get iconColor {
    switch (type) {
      case 'servicio':
        return const Color(0xFF1F3C88);
      case 'finanzas':
        return Colors.green.shade700;
      case 'sistema':
        return Colors.grey.shade700;
      default:
        return const Color(0xFF1F3C88);
    }
  }

  IconData get iconData {
    switch (type) {
      case 'servicio':
        return Icons.car_repair;
      case 'finanzas':
        return Icons.attach_money;
      case 'sistema':
        return Icons.info_outline;
      default:
        return Icons.notifications;
    }
  }
}
