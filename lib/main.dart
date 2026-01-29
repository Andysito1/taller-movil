import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xtreme_performance/screens/ajustes_page.dart';
import 'package:xtreme_performance/screens/diagnostico_page.dart';
import 'package:xtreme_performance/screens/estado_financiero.dart';
import 'package:xtreme_performance/screens/finalizacion_page.dart';
import 'package:xtreme_performance/screens/historial_vehiculo.dart';
import 'package:xtreme_performance/screens/login_page.dart';
import 'package:xtreme_performance/screens/my_home_page.dart';
import 'package:xtreme_performance/screens/pruebas_page.dart';
import 'package:xtreme_performance/screens/reparacion_page.dart';
import 'package:xtreme_performance/screens/seguimiento_page.dart';

void main() {
  runApp(const MyApp());
}

// Configuracion
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const MyHomePage(title: "Xtreme Performance");
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginPage();
          },
        ),

        GoRoute(
          path: 'seguimiento',
          builder: (BuildContext context, GoRouterState state) {
            return const SeguimientoPage();
          },
        ),

        GoRoute(
          path: 'estadoFinanciero',
          builder: (BuildContext context, GoRouterState state) {
            return const EstFinancieroPage();
          },
        ),

        GoRoute(
          path: 'historial',
          builder: (BuildContext context, GoRouterState state) {
            return const HistorialPage();
          },
        ),

        GoRoute(
          path: 'ajustes',
          builder: (BuildContext context, GoRouterState state) {
            return const AjustesPage();
          },
        ),

        GoRoute(
          path: 'diagnostico',
          builder: (BuildContext context, GoRouterState state) {
            return const DiagnosticoPage();
          },
        ),

        GoRoute(
          path: 'reparacion',
          builder: (BuildContext context, GoRouterState state) {
            return const ReparacionPage();
          },
        ),

        GoRoute(
          path: 'pruebas',
          builder: (BuildContext context, GoRouterState state) {
            return const PruebasPage();
          },
        ),

        GoRoute(
          path: 'final',
          builder: (BuildContext context, GoRouterState state) {
            return const FinalPage();
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: _router);
  }
}
