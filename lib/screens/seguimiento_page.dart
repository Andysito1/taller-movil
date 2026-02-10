// Seguimiento del vehiculo

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SeguimientoPage extends StatefulWidget {
  const SeguimientoPage({super.key});

  @override
  State<SeguimientoPage> createState() => _SeguimientoPageState();
}

class _SeguimientoPageState extends State<SeguimientoPage> {
  // ===== VEHÍCULOS MOCK (LUEGO VIENEN DEL API CON DIO) =====
  final List<Map<String, String>> _vehiculos = [
    {
      "marca": "Toyota Corolla",
      "anio": "2018",
      "placa": "ABC-1234",
      "imagen": "URL_IMAGEN_VEHICULO_AQUI", // 👈 AQUÍ VA EL LINK DE LA IMAGEN
    },
    {
      "marca": "Hyundai Tucson",
      "anio": "2020",
      "placa": "XYZ-456",
      "imagen": "URL_IMAGEN_VEHICULO_AQUI", // 👈 AQUÍ VA EL LINK DE LA IMAGEN
    },
  ];

  int _vehiculoSeleccionado = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F3C88),
        title: const Text(
          "Xtreme Performance",
          style: TextStyle(color: Colors.white),
        ),
      ),

      // drawer del menú
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF1F3C88),
          child: Column(
            children: [
              // header
              Container(
                color: const Color(0xFFE53935),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Xtreme Performance",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Andy Sullcaray",
                            style: TextStyle(
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
                selected: true,
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
                icon: Icons.settings,
                text: "Notificaciones",
                route: "/notificaciones",
              ),
              _drawerItem(
                context,
                icon: Icons.settings,
                text: "Ajustes",
                route: "/ajustes",
              ),

              const Spacer(),

              // VEHÍCULO (drawer)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C5BEA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          "URL_IMAGEN_VEHICULO_AQUI", // 👈 AQUÍ VA EL LINK DE LA IMAGEN
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 50,
                            height: 50,
                            color: Colors.white24,
                            child: const Icon(
                              Icons.directions_car,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Toyota Corolla 2018",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Placa: ABC-1234",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // seguimiento del servicio
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== SELECTOR DE VEHÍCULO (AGREGADO) =====
            GestureDetector(
              onTap: () => _mostrarSelectorVehiculo(context),
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D1B3E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red, width: 1.5),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        _vehiculos[_vehiculoSeleccionado]["imagen"]!,
                        // 👈 AQUÍ VA EL LINK DE LA IMAGEN DEL VEHÍCULO
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 55,
                          height: 55,
                          color: Colors.white24,
                          child: const Icon(
                            Icons.directions_car,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${_vehiculos[_vehiculoSeleccionado]["marca"]} ${_vehiculos[_vehiculoSeleccionado]["anio"]}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Placa: ${_vehiculos[_vehiculoSeleccionado]["placa"]}",
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down, color: Colors.red),
                  ],
                ),
              ),
            ),

            // ===== TU CÓDIGO ORIGINAL CONTINÚA =====
            const Text(
              "Seguimiento del Servicio",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              "Estado actual de tu vehículo",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            _etapaServicio(
              context,
              icon: Icons.assignment_turned_in,
              color: Colors.green,
              titulo: "Diagnóstico",
              descripcion: "Inspección inicial y diagnóstico del vehículo",
              estado: "Completado",
              fecha: "2 de Enero, 2026 - 09:30",
              ruta: "/diagnostico",
            ),

            _etapaServicio(
              context,
              icon: Icons.build,
              color: Colors.orange,
              titulo: "Reparación",
              descripcion: "Reparación de componentes identificados",
              estado: "En progreso",
              fecha: "3 de Enero, 2026 - 10:15",
              ruta: "/reparacion",
            ),

            _etapaServicio(
              context,
              icon: Icons.science,
              color: Colors.grey,
              titulo: "Pruebas",
              descripcion: "Pruebas de funcionamiento y calidad",
              estado: "Pendiente",
              fecha: "Por iniciar",
              ruta: "/pruebas",
            ),

            _etapaServicio(
              context,
              icon: Icons.check_circle,
              color: Colors.grey,
              titulo: "Finalización",
              descripcion: "Revisión final y entrega del vehículo",
              estado: "Pendiente",
              fecha: "Por iniciar",
              ruta: "/final",
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Nota: Puedes hacer clic en cada etapa para ver más detalles y aprobar el avance del servicio.",
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== BOTTOM SHEET SELECTOR DE VEHÍCULO =====
  void _mostrarSelectorVehiculo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: _vehiculos.length,
            itemBuilder: (_, i) {
              final v = _vehiculos[i];
              final seleccionado = i == _vehiculoSeleccionado;

              return InkWell(
                onTap: () {
                  setState(() => _vehiculoSeleccionado = i);
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: seleccionado ? Colors.red : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          v["imagen"]!,
                          // 👈 AQUÍ VA EL LINK DE LA IMAGEN DEL VEHÍCULO
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.directions_car),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${v["marca"]} ${v["anio"]}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Placa: ${v["placa"]}",
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      if (seleccionado)
                        const Icon(Icons.check_circle, color: Colors.red),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// ===== drawer item =====
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
      context.go(route);
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

// ===== etapa del servicio =====
Widget _etapaServicio(
  BuildContext context, {
  required IconData icon,
  required Color color,
  required String titulo,
  required String descripcion,
  required String estado,
  required String fecha,
  required String ruta,
}) {
  return InkWell(
    onTap: () => context.go(ruta),
    child: Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(descripcion, style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  fecha,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            estado,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}
