// lib/main.dart

import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const FeedbackApp());
}

class FeedbackApp extends StatelessWidget {
  const FeedbackApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi warna yang konsisten
    const Color primaryDeepBlue = Color.fromRGBO(201, 196, 98, 1); // Deep Blue/Indigo
    const Color accentLightBlue = Color.fromARGB(255, 123, 126, 128); // Light Blue/Sky Blue

    return MaterialApp(
      // PASTIKAN NAMA APLIKASI SESUAI INSTRUKSI
      title: 'form_feedback_app', // Mengubah title untuk mencerminkan nama tugas
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Tema utama: Menggunakan Material 3
        useMaterial3: true,
        fontFamily: 'Montserrat',

        // PERBAIKAN: Menggunakan ColorScheme secara langsung untuk menghindari parameter usang.
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryDeepBlue, // Warna utama sebagai 'benih'
          primary: primaryDeepBlue, // Primary color
          secondary: accentLightBlue, // Accent/Secondary color
        ),

        // Pengaturan App Bar
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryDeepBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),

        // Pengaturan Input Form
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.blueGrey.shade50,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),

        // Pengaturan Tombol
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentLightBlue, // Light Blue untuk tombol aksi
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15),
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}