// diagnostico

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DiagnosticoPage extends StatefulWidget {
  const DiagnosticoPage({super.key});

  @override
  State<DiagnosticoPage> createState() => _DiagnosticoPageState();
}

class _DiagnosticoPageState extends State<DiagnosticoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('Diagnóstico'),

            ElevatedButton(
              onPressed: () {
                context.go("/seguimiento");
              },
              child: const Text("<-"),
            ),
          ],
        ),
      ),
    );
  }
}
