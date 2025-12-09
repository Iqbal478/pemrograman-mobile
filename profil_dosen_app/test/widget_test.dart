// test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Import file utama aplikasi (Menggantikan nama proyek dengan 'profil_dosen_app')
import 'package:profil_dosen_app/main.dart';

void main() {
  // Mengubah deskripsi pengujian agar sesuai dengan aplikasi profil dosen
  testWidgets('Aplikasi Profil Dosen memuat, menampilkan nama dosen, dan navigasi', (WidgetTester tester) async {

    // 1. Muat aplikasi utama Anda (ProfilDosenApp)
    // Pastikan ProfilDosenApp memiliki konstruktor 'const' di main.dart
    await tester.pumpWidget(const ProfilDosenApp());

    // Tunggu hingga semua operasi asinkron (seperti memuat gambar) selesai
    await tester.pumpAndSettle();

    // 2. Verifikasi Konten Halaman Daftar (Halaman 1)

    // Periksa judul AppBar (Sesuaikan dengan home_screen.dart)
    expect(find.text('Profil Dosen Kampus'), findsOneWidget);

    // Cek nama dosen pertama (sesuaikan dengan dosen.dart)
    const namaDosen1 = 'Dr. Budi Santoso, S.Kom., M.T.';
    expect(find.text(namaDosen1), findsOneWidget);

    // Cek nama dosen kedua (sesuaikan dengan dosen.dart)
    const namaDosen2 = 'Prof. Dr. Siti Aminah, M.Sc.';
    expect(find.text(namaDosen2), findsOneWidget);

    // --- Pengujian Navigasi ---

    // Cari widget Card/InkWell yang memiliki nama dosen pertama
    final dosenCardFinder = find.widgetWithText(Card, namaDosen1);

    // Tap Card tersebut
    await tester.tap(dosenCardFinder);

    // Trigger frame setelah navigasi (penting untuk Navigator)
    await tester.pumpAndSettle();

    // 3. Verifikasi Konten Halaman Detail (Halaman 2)

    // Judul AppBar halaman detail hanya menampilkan "Detail Dosen" (sesuai detail_screen.dart)
    expect(find.text('Detail Dosen'), findsOneWidget);

    // Pastikan nama dosen secara penuh muncul di bagian body halaman detail
    expect(find.text(namaDosen1), findsOneWidget);

    // Pastikan elemen detail NIDN muncul di halaman detail (NIDN Dosen Budi)
    const nidnDosen1 = '0012098001';
    expect(find.textContaining(nidnDosen1), findsOneWidget);
  });
}