import 'dart:async';
import 'dart:convert';
import 'package:xtreme_performance/models/notification_model.dart';
import 'package:xtreme_performance/services/pusher_config.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class NotificationsService {
  // Singleton para asegurar una única instancia del servicio
  NotificationsService._privateConstructor();
  static final NotificationsService _instance =
      NotificationsService._privateConstructor();
  factory NotificationsService() {
    return _instance;
  }

  final PusherConfig _pusherConfig = PusherConfig();
  final _notificationsController =
      StreamController<List<NotificationModel>>.broadcast();
  final List<NotificationModel> _notifications = [];

  Stream<List<NotificationModel>> get notificationsStream =>
      _notificationsController.stream;

  void init() {
    // Evita reinicializar si ya está conectado
    if (_pusherConfig.pusher.connectionState == 'CONNECTED') return;

    _pusherConfig.initPusher(
      channelName: "mi-channel",
      eventName: "mi-event",
      onEventTriggered: (PusherEvent event) {
        try {
          dynamic eventData;
          if (event.data is String) {
            eventData = jsonDecode(event.data);
          } else {
            eventData = event.data;
          }

          // Asumimos que la data de la notificación está en una clave 'mensaje'
          final newNotification = NotificationModel.fromJson(
            eventData['mensaje'] as Map<String, dynamic>,
          );

          _notifications.insert(0, newNotification);
          _notificationsController.add(List.from(_notifications));
        } catch (e) {
          print("Error al procesar evento de Pusher: $e");
        }
      },
    );
  }

  void dispose() {
    _pusherConfig.disconnect();
    _notificationsController.close();
  }
}
