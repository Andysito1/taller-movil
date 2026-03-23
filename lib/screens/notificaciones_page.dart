import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xtreme_performance/models/notification_model.dart';
import 'package:xtreme_performance/models/usuario_model.dart';
import 'package:xtreme_performance/services/notifications_service.dart';
import 'package:xtreme_performance/services/usuario_service.dart';

class NotificacionesPage extends StatefulWidget {
  const NotificacionesPage({super.key});

  @override
  State<NotificacionesPage> createState() => _NotificacionesPageState();
}

class _NotificacionesPageState extends State<NotificacionesPage> {
  // Instanciamos el servicio que actúa como Provider/Controller
  final NotificationsService _notificationsService = NotificationsService();

  final UsuarioService _usuarioService = UsuarioService();
  UsuarioModel? _usuario;

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
  }

  Future<void> _cargarUsuario() async {
    try {
      final usuariosJson = await _usuarioService.usuarioInfo();
      if (usuariosJson.isNotEmpty && mounted) {
        // Asumimos que el backend devuelve un usuario con ID válido
        setState(() => _usuario = UsuarioModel.fromJson(usuariosJson.first));

        if (_usuario != null) {
          // Usamos el ID numérico del usuario para el canal
          final userId = int.tryParse(_usuario!.id.toString()) ?? 0;
          _notificationsService.init(userId);
        }
      }
    } catch (e) {
      print("Error al cargar el usuario: $e");
    }
  }

  @override
  void dispose() {
    _notificationsService.dispose();
    super.dispose();
  }

  String _timeAgo(DateTime date) {
    final duration = DateTime.now().difference(date);
    if (duration.inDays > 0) {
      return 'Hace ${duration.inDays} día${duration.inDays == 1 ? '' : 's'}';
    } else if (duration.inHours > 0) {
      return 'Hace ${duration.inHours} hora${duration.inHours == 1 ? '' : 's'}';
    } else if (duration.inMinutes > 0) {
      return 'Hace ${duration.inMinutes} minuto${duration.inMinutes == 1 ? '' : 's'}';
    } else {
      return 'Justo ahora';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E4A8F),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Xtreme Performance",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode_outlined, color: Colors.white),
            onPressed: () {}, // Visual only
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notificaciones',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Actualizaciones de tus servicios',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 30),
                  _buildSectionTitle('HISTORIAL DE NOTIFICACIONES'),
                ],
              ),
            ),
          ),
          // Corrección: Usamos ListenableBuilder en lugar de SliverAnimatedList
          ListenableBuilder(
            listenable: _notificationsService,
            builder: (context, child) {
              if (_notificationsService.isLoading) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (_notificationsService.notifications.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text("No tienes notificaciones.")),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildNotificationCard(
                    context,
                    _notificationsService.notifications[index],
                  ),
                  childCount: _notificationsService.notifications.length,
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFFE53935),
        child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    NotificationModel notification,
  ) {
    return InkWell(
      onTap: () {
        if (!notification.isRead) {
          _notificationsService.markAsRead(notification.id);
        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Container(
          decoration: BoxDecoration(
            color: notification.isRead
                ? Colors.white
                : Colors.blue.shade50.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: notification.iconBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  notification.iconData,
                  color: notification.iconColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.description,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _timeAgo(notification.timestamp),
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (!notification.isRead)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(left: 8, top: 4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF757575),
        fontWeight: FontWeight.w600,
        fontSize: 12,
        letterSpacing: 1.0,
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: Container(
        color: const Color(0xFF1F3C88),
        child: Column(
          children: [
            Container(
              color: const Color(0xFFE53935),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                bottom: 24,
                left: 16,
                right: 16,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Xtreme Performance",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _usuario?.nombre ?? "Cliente",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            _drawerItem(
              context,
              icon: Icons.directions_car,
              text: "Seguimiento del vehículo",
              route: "/seguimiento",
            ),
            _drawerItem(
              context,
              icon: Icons.attach_money,
              text: "Estado financiero",
              route: "/estadoFinanciero",
            ),
            _drawerItem(
              context,
              icon: Icons.history,
              text: "Historial del vehículo",
              route: "/historial",
            ),
            _drawerItem(
              context,
              icon: Icons.notifications,
              text: "Notificaciones",
              route: "/notificaciones",
              selected: true,
            ),
            _drawerItem(
              context,
              icon: Icons.settings,
              text: "Ajustes",
              route: "/ajustes",
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Versión 1.0.0",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _drawerItem(
  BuildContext context, {
  required IconData icon,
  required String text,
  required String route,
  bool selected = false,
}) {
  return InkWell(
    onTap: () {
      Navigator.pop(context);
      if (!selected) {
        context.go(route);
      }
    },
    child: Container(
      color: selected ? const Color(0xFF2C5BEA) : Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 14),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    ),
  );
}
