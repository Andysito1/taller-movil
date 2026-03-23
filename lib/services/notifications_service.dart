import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:xtreme_performance/models/notification_model.dart';
import 'package:xtreme_performance/utils/dio_client.dart';

class NotificationsService extends ChangeNotifier {
  final PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  List<NotificationModel> _notifications = [];
  bool _isLoading = false;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;

  /// Inicializa cargando historial y conectando al socket
  Future<void> init(int userId) async {
    await _fetchHistorial();
    await _initPusher(userId);
  }

  /// Carga notificaciones antiguas desde la API REST
  Future<void> _fetchHistorial() async {
    _isLoading = true;
    notifyListeners();

    try {
      await DioClient.setTokenHeader();
      final response = await DioClient.dio.get('/notificaciones');

      if (response.statusCode == 200 && response.data is List) {
        _notifications = (response.data as List)
            .map((json) => NotificationModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      print("Error cargando historial: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Conecta a Pusher para escuchar eventos en tiempo real
  Future<void> _initPusher(int userId) async {
    try {
      await pusher.init(
        apiKey: "44fe0f1bb58c3cfe14fb",
        cluster: "mt1",
        onEvent: _onPusherEvent,
      );

      await pusher.subscribe(channelName: "cliente.$userId");
      await pusher.connect();
      print("🔌 Pusher conectado al canal: cliente.$userId");
    } catch (e) {
      print("Error conectando a Pusher: $e");
    }
  }

  /// Maneja los eventos entrantes
  void _onPusherEvent(PusherEvent event) {
    if (event.eventName == 'nuevo-evento') {
      print("🔔 Nuevo evento recibido: ${event.data}");

      dynamic data = event.data;

      // Si llega como String, lo decodificamos a JSON
      if (data is String) {
        data = jsonDecode(data);
      }

      // Convertimos el mapa genérico a Map<String, dynamic>
      if (data is Map) {
        final jsonMap = Map<String, dynamic>.from(data);
        final nuevaNotificacion = NotificationModel.fromJson(jsonMap);

        // Agregamos al inicio de la lista
        _notifications.insert(0, nuevaNotificacion);
        notifyListeners();
      }
    }
  }

  /// Marca una notificación como leída en API y localmente
  Future<void> markAsRead(String id) async {
    // 1. Actualización optimista en UI
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      notifyListeners();
    }

    // 2. Llamada al backend
    try {
      await DioClient.dio.put('/notificaciones/$id/leer');
    } catch (e) {
      print("Error marcando como leído: $e");
      // Revertir si falla (opcional)
    }
  }

  @override
  void dispose() {
    pusher.disconnect();
    super.dispose();
  }
}
