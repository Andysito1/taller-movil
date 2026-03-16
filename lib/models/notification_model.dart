import 'package:flutter/material.dart';

class NotificationModel {
  final String id;
  final String type;
  final String title;
  final String description;
  final DateTime timestamp;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? UniqueKey().toString(),
      type: json['type'] ?? 'info',
      title: json['title'] ?? 'Sin Título',
      description: json['description'] ?? 'Sin Descripción',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  Color get iconBackgroundColor {
    switch (type) {
      case 'success':
        return Colors.green.shade50;
      case 'alert':
        return Colors.red.shade50;
      case 'info':
        return Colors.blue.shade50;
      case 'update':
        return Colors.orange.shade50;
      default:
        return Colors.grey.shade100;
    }
  }

  Color get iconColor {
    switch (type) {
      case 'success':
        return Colors.green;
      case 'alert':
        return Colors.red;
      case 'info':
        return Colors.blue;
      case 'update':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData get iconData {
    switch (type) {
      case 'success':
        return Icons.check_circle_outline;
      case 'alert':
        return Icons.warning_amber_rounded;
      case 'info':
        return Icons.info_outline;
      case 'update':
        return Icons.system_update_alt_rounded;
      default:
        return Icons.notifications;
    }
  }
}
