import 'dart:convert';
import 'package:flutter/material.dart';
import '/services/pusher_config.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.title});
  final String title;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final PusherConfig _pusherConfig = PusherConfig();
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _mensajes = []; // Lista para guardar el historial
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();


    _pusherConfig.initPusher(
      channelName: "chat-channel", // Asegúrate que coincida con tu backend
      eventName: "new-message",
      onEventTriggered: (event) {
        if (!mounted) return;
        
        dynamic data = (event.data is String) 
            ? jsonDecode(event.data.toString()) 
            : event.data;

        setState(() {
          _mensajes.add({
            "texto": data['mensaje'] ?? "...",
            "esMio": false, // Marcamos como recibido de otro
          });
        });
        _scrollToBottom();
      },
    );
  }


  Future<void> _enviarMensaje() async {
    if (_controller.text.isEmpty) return;

    final texto = _controller.text;
    _controller.clear();

    // 1. Lo agregamos localmente para que se vea al instante
    setState(() {
      _mensajes.add({"texto": texto, "esMio": true});
    });
    _scrollToBottom();

    // 2. Enviarlo a tu servidor (Ajusta la URL)
    try {
      await http.post(
        Uri.parse('http://127.0.0.1:8000/api/send-message'),
        body: jsonEncode({'mensaje': texto}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print("Error enviando: $e");
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          // Área de mensajes
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(10),
              itemCount: _mensajes.length,
              itemBuilder: (context, index) {
                final msg = _mensajes[index];
                return Align(
                  alignment: msg['esMio'] ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg['esMio'] ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(msg['texto']),
                  ),
                );
              },
            ),
          ),
          // Input de texto
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Escribe un mensaje...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _enviarMensaje,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}