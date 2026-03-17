import 'dart:async';
import 'dart:convert';
import 'package:xtreme_performance/models/notification_model.dart';
import 'package:xtreme_performance/services/pusher_config.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class NotificationsService {
  // Singleton
  NotificationsService._privateConstructor();
  static final NotificationsService _instance =
      NotificationsService._privateConstructor();
  factory NotificationsService() => _instance;

  final PusherConfig _pusherConfig = PusherConfig();

  final StreamController<List<NotificationModel>> _notificationsController =
      StreamController<List<NotificationModel>>.broadcast();

  final List<NotificationModel> _notifications = [];

  Stream<List<NotificationModel>> get notificationsStream =>
      _notificationsController.stream;

  bool _initialized = false;

  Future<void> init() async {
    // Evitar inicializar varias veces
    if (_initialized) return;

    try {
      print("Inicializando servicio de notificaciones...");

      await _pusherConfig.initPusher(
        channelName: "notifications-channel",
        eventName: "new-notification",
        onEventTriggered: (PusherEvent event) {
          try {
            print("Evento Pusher recibido:");
            print(event.data);

            dynamic eventData;

            if (event.data is String) {
              eventData = jsonDecode(event.data);
            } else {
              eventData = event.data;
            }

            // Conversión segura para Flutter Web
            final Map<String, dynamic> notificationMap =
                Map<String, dynamic>.from(eventData);

            final newNotification =
                NotificationModel.fromJson(notificationMap);

            _notifications.insert(0, newNotification);

            print("Notificación agregada: ${newNotification.title}");

            _notificationsController.add(List.from(_notifications));
          } catch (e) {
            print("Error al procesar evento de Pusher: $e");
          }
        },
      );

      _initialized = true;
      print("Servicio de notificaciones inicializado correctamente.");
    } catch (e) {
      print("Error al inicializar NotificationsService: $e");
    }
  }

  void dispose() {
    _pusherConfig.disconnect();
    _notificationsController.close();
  }
}