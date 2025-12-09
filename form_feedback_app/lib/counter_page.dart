// lib/counter_page.dart

import 'package:flutter/material.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter Page (Tidak Digunakan)')),
      body: const Center(
        child: Text(
          'Halaman ini tidak diimplementasikan untuk tugas feedback.',
        ),
      ),
    );
  }
}
