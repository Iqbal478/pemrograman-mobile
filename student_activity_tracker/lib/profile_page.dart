// lib/profile_page.dart

import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final Function(bool) onThemeChanged;
  final bool isDark;
  
  // Halaman Profile untuk menampilkan identitas dan toggle Dark Mode (Bonus Poin)
  const ProfilePage({super.key, required this.onThemeChanged, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Bagian Identitas
          const Center(child: CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40))),
          const SizedBox(height: 16),
          const Center(child: Text('M.Iqbal', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700))),
          const Center(child: Text('NIM: 701230046')), // Contoh penambahan detail
          const SizedBox(height: 8),
          const Center(child: Text('Prodi: Sistem Informasi - UIN STS Jambi', style: TextStyle(color: Colors.grey))),
          const Divider(height: 30),
          
          // Toggle Dark Mode (Bonus Poin)
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Mode Gelap (Dark Mode) 🌙', style: TextStyle(fontSize: 16)),
            Switch(value: isDark, onChanged: onThemeChanged)
          ]),
          const Divider(height: 30),
          
          // Dokumentasi Proyek
          const Text('Catatan Proyek 📜', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const Text('Aplikasi ini dibuat sebagai bagian dari Ujian Tengah Semester (UTS) mata kuliah Pemrograman Perangkat Bergerak (Flutter). Seluruh fungsionalitas utama dan bonus (SharedPreferences, Search, BottomNav, Dark Mode) telah diimplementasikan.'),
        ]),
      ),
    );
  }
}