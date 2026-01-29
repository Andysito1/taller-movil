// Finalización

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FinalPage extends StatefulWidget {
  const FinalPage({super.key});

  @override
  State<FinalPage> createState() => _FinalPageState();
}

class _FinalPageState extends State<FinalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('Finalización'),

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
