import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'dart:developer';

class PusherConfig {
  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  Future<void> initPusher({
    required String channelName,
    required String eventName,
    required Function(PusherEvent) onEventTriggered,
  }) async {
    try {
      await pusher.init(
        apiKey: "44fe0f1bb58c3cfe14fb",
        cluster: "mt1",
        onConnectionStateChange: (currentState, previousState) {
          log("Conexión: $previousState -> $currentState");
        },
        onError: (message, code, e) {
          log("Error Pusher: $message (Código: $code)");
        },
        onEvent: (PusherEvent event) {
          log("Evento recibido: ${event.eventName}");
          log("Canal: ${event.channelName}");
          log("Data: ${event.data}");

          if (event.channelName == channelName &&
              event.eventName == eventName) {
            onEventTriggered(event);
          }
        },
        onSubscriptionSucceeded: (channel, data) {
          log("Suscrito con éxito a: $channel");
        },
      );

      await pusher.subscribe(channelName: channelName);
      await pusher.connect();
    } catch (e) {
      log("Error al inicializar Pusher: $e");
    }
  }

  void disconnect() {
    pusher.disconnect();
  }
}