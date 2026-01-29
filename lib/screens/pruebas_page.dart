// Pruebas

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PruebasPage extends StatefulWidget {
  const PruebasPage({super.key});

  @override
  State<PruebasPage> createState() => _PruebasPageState();
}

class _PruebasPageState extends State<PruebasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('Pruebas'),

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
