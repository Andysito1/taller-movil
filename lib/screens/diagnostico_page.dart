import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../services/orden_service.dart';

class DiagnosticoPage extends StatefulWidget {
  final String? ordenId;
  const DiagnosticoPage({super.key, this.ordenId});

  @override
  State<DiagnosticoPage> createState() => _DiagnosticoPageState();
}

class _DiagnosticoPageState extends State<DiagnosticoPage> {
  final OrdenService _ordenService = OrdenService();

  bool _isProcessing = false;
  bool _isLoadingData = true;
  // Estados: 'en_espera', 'aprobado', 'aclaracion'
  String _validacionStatus = 'en_espera';
  String _estadoGeneral = 'en_proceso';
  String _descripcionDiagnostico = "Cargando descripción...";
  String _fechaDiagnostico = "--/--/----";

  @override
  void initState() {
    super.initState();
    _cargarInformacionOrden();
  }

  Future<void> _cargarInformacionOrden() async {
    if (widget.ordenId == null || widget.ordenId == "0") {
      setState(() => _isLoadingData = false);
      return;
    }

    final data = await _ordenService.obtenerOrden(widget.ordenId!);
    if (data != null && mounted) {
      setState(() {
        _validacionStatus = data['validacion_diagnostico'] ?? 'en_espera';
        _estadoGeneral = data['estado'] ?? 'en_proceso';
        _descripcionDiagnostico =
            data['descripcion'] ?? 'Sin descripción disponible.';
        _fechaDiagnostico = data['updated_at'] ?? '--/--/----';
        _isLoadingData = false;
      });
    }
  }

  Future<void> _handleAction(
    Future<bool> Function() action,
    String successMsg, {
    String? nextStatus,
    String? nextGeneralStatus,
  }) async {
    if (widget.ordenId == null) return;

    setState(() => _isProcessing = true);

    final success = await action();

    if (mounted) {
      setState(() => _isProcessing = false);
      if (success) {
        if (nextStatus != null) setState(() => _validacionStatus = nextStatus);
        if (nextGeneralStatus != null)
          setState(() => _estadoGeneral = nextGeneralStatus);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMsg),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error al procesar la solicitud. Intente de nuevo."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          child: GestureDetector(
            onTap: () => context.go('/seguimiento'),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ),
        leadingWidth: 56,
      ),
      body: _isLoadingData
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // 1. Cabecera con Imagen
                _buildHeaderImage(context),

                // Contenido principal
                ListView(
                  padding: const EdgeInsets.only(
                    top: 200,
                    left: 16,
                    right: 16,
                    bottom: 100,
                  ),
                  children: [
                    _buildInfoCard(),
                    const SizedBox(height: 24),
                    _buildNotesBox(),
                    const SizedBox(height: 24),
                    if (_validacionStatus == 'aprobado')
                      _buildSuccessPanel()
                    else
                      _buildApprovalPanel(context),
                  ],
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

  Widget _buildHeaderImage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.28,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            "https://images.unsplash.com/photo-1553787764-8134b2d94759?q=80&w=2070&auto=format&fit=crop",
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0xFFE53935),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.assignment_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Diagnóstico",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _fechaDiagnostico,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Estado:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _estadoGeneral == 'pausado'
                      ? Colors.orange.shade100
                      : const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _estadoGeneral == 'pausado' ? "Pausado" : "Completado",
                  style: TextStyle(
                    color: _estadoGeneral == 'pausado'
                        ? Colors.orange.shade900
                        : const Color(0xFF2E7D32),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildNotesBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Notas del técnico",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Text(
            _descripcionDiagnostico,
            style: TextStyle(color: Colors.grey.shade800, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessPanel() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF81C784)),
      ),
      child: Column(
        children: const [
          Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 48),
          SizedBox(height: 12),
          Text(
            "Diagnóstico Aprobado",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          SizedBox(height: 4),
          Text(
            "Vehículo en Reparación",
            style: TextStyle(color: Color(0xFF2E7D32)),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Aprobación del Cliente",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            context: context,
            label: "Aprobar avance",
            icon: Icons.check,
            color: Colors.green,
            onPressed: _isProcessing
                ? null
                : () => _handleAction(
                    () => _ordenService.validarDiagnostico(widget.ordenId!),
                    "¡Diagnóstico aprobado! Iniciando reparación.",
                    nextStatus: 'aprobado',
                  ),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            context: context,
            label: "Solicitar aclaración",
            icon: Icons.error_outline,
            color: Colors.orange.shade800,
            onPressed: _isProcessing
                ? null
                : () => _handleAction(
                    () => _ordenService.solicitarAclaracion(widget.ordenId!),
                    "Solicitud enviada. El técnico revisará tus dudas.",
                    nextStatus: 'aclaracion',
                  ),
          ),
          const SizedBox(height: 16),
          Text(
            "Al aprobar, autorizas al taller a continuar con el siguiente paso del servicio.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    VoidCallback? onPressed,
  }) {
    return _isProcessing
        ? const Center(child: CircularProgressIndicator())
        : ElevatedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, color: Colors.white),
            label: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
            ),
          );
  }
}
