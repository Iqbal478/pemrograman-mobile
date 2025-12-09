// lib/main.dart

import 'package:flutter/material.dart';
import 'home_screen.dart'; 

// --- MODEL & DATA (Dipindahkan dari file dosen.dart yang tidak ada) ---

class Dosen {
  final String nama;
  final String nidn;
  final String bidangKeahlian;
  final String email;
  final String fotoUrl;
  final String deskripsiSingkat;
  final String riwayatPendidikan;

  const Dosen({
    required this.nama,
    required this.nidn,
    required this.bidangKeahlian,
    required this.email,
    required this.fotoUrl,
    required this.deskripsiSingkat,
    required this.riwayatPendidikan,
  });
}

const List<Dosen> daftarDosen = [
  Dosen(
    nama: 'Ahmad Nasukha, S.Hum., M.S.I',
    nidn: '0012098001',
    bidangKeahlian: 'Kecerdasan Buatan & Data Science',
    email: 'ahmad.nasukha@UinJambbi.ac.id',
    fotoUrl: 'assets/images/poto1.png',
    deskripsiSingkat: 'Pakar AI dengan fokus pada Machine Learning dan Big Data. Berpengalaman 15 tahun.',
    riwayatPendidikan: 'S3 Ilmu Komputer (UI), S2 Teknik Elektro (ITB), S1 Sistem Informasi (UGM).',
  ),
  Dosen(
    nama: 'Prof. Dr. M.Iqbal, M.Kom.',
    nidn: '0025057502',
    bidangKeahlian: 'Rekayasa Perangkat Lunak & Pengembangan Aplikasi Mobile',
    email: 'iqbaleee@uinJambi.ac.id',
    fotoUrl: 'assets/images/poto2.jpg',
    deskripsiSingkat: 'Peneliti senior di bidang Software Engineering dan pengembang aplikasi multi-platform.',
    riwayatPendidikan: 'S3 Computer Science (MIT), S2 Computer Science (Stanford), S1 Teknik Informatika (ITS).',
  ),
  Dosen(
    nama: 'Wahyu Anggoro, M.Kom.',
    nidn: '0010049203',
    bidangKeahlian: 'Jaringan Komputer & Keamanan Siber',
    email: 'wahyu.anggoro@UinJambi.ac.id',
    fotoUrl: 'assets/images/poto3.jpg',
    deskripsiSingkat: 'Ahli di bidang keamanan jaringan, firewall, dan penetration testing.',
    riwayatPendidikan: 'S2 Ilmu Komputer (UGM), S1 Teknik Informatika (UNS).',
  ),
];

// --- FUNGSI UTAMA & WIDGET APLIKASI ---

void main() {
  runApp(const ProfilDosenApp());
}

// 💡 Ini adalah kelas yang dibutuhkan oleh widget_test.dart
class ProfilDosenApp extends StatelessWidget {
  // 💡 Konstruktor 'const' wajib agar tes dapat berjalan
  const ProfilDosenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Profil Dosen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}