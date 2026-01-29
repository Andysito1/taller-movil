// Reparación

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReparacionPage extends StatefulWidget {
  const ReparacionPage({super.key});

  @override
  State<ReparacionPage> createState() => _ReparacionPageState();
}

class _ReparacionPageState extends State<ReparacionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('Reparación'),

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
