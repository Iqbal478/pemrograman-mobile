// screens/TabsScreen.dart
import 'package:flutter/material.dart';
// Ganti dengan import yang benar ke file details.dart
import 'package:flutter_navigation_demo/screens/details.dart'; 

// -----------------------------------------------------------
// TAB A: Daftar Pesan dan Navigasi (Mengirim Data)
// -----------------------------------------------------------

class TabA extends StatelessWidget {
  const TabA({super.key});

  // Data dummy untuk list pesan
  final List<Map<String, String>> messages = const [
    {'name': 'M.Iqbal, S.Kom', 'subject': 'Proyek baru sudah dimulai.', 'avatar': 'B'},
    {'name': 'Ahmad Nasukha, S.Hum., M.S.I', 'subject': 'Konfirmasi jadwal meeting besok.', 'avatar': 'S'},
    {'name': 'Pol Metra,  M.Kom', 'subject': 'Laporan triwulan sudah siap.', 'avatar': 'J'},
    {'name': 'M. Yusuf, S.Kom., M.S.I', 'subject': 'Review dokumen perjanjian.', 'avatar': 'D'},
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Klik pesan untuk melihat detail dan mengirim balasan (Navigator.push() dengan data).',
            style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final msg = messages[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    // Menggunakan avatar inisial (simulasi foto)
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    child: Text(msg['avatar']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  title: Text(
                    msg['name']!,
                    style: TextStyle(fontWeight: FontWeight.w500, color: colorScheme.primary),
                  ),
                  subtitle: Text(msg['subject']!),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // **PERBAIKAN:** Mengganti TabsScreen menjadi DetailScreen
                    // Navigator.push() untuk membuka DetailScreen dan MENGIRIM DATA
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(
                          message: 'Pesan dari ${msg['name']} tentang: ${msg['subject']}', 
                          senderName: msg['name']!,
                          senderAvatar: msg['avatar']!,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------
// TAB B: Halaman Profil (Visual Menarik dengan Informasi)
// -----------------------------------------------------------

class TabB extends StatelessWidget {
  const TabB({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Placeholder Foto Profil
          CircleAvatar(
            radius: 60,
            backgroundColor: colorScheme.secondary,
            child: Icon(Icons.verified_user, size: 80, color: colorScheme.onSecondary),
          ),
          const SizedBox(height: 16),
          Text(
            'Pengguna Demo Flutter',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: colorScheme.primary),
          ),
          Text(
            'Demonstrasi UI Material 3',
            style: TextStyle(fontSize: 16, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 40),
          // Kartu Informasi Profil
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildProfileInfo(context, Icons.email, 'Email', 'user.demo@flutter.dev'),
                  _buildProfileInfo(context, Icons.phone, 'Telepon', '+62 812-xxxx-xxxx'),
                  _buildProfileInfo(context, Icons.settings_applications, 'Level', 'Intermediate Dev'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context, IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.secondary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// -----------------------------------------------------------
// TAB C: Halaman Tentang
// -----------------------------------------------------------

class TabC extends StatelessWidget {
  const TabC({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.flutter_dash, size: 80, color: colorScheme.tertiary),
          const SizedBox(height: 20),
          Text(
            'Flutter Navigation Demo App',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colorScheme.tertiary),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Aplikasi ini mendemonstrasikan navigasi dasar Flutter: push untuk mengirim data, pop untuk kembali dan mengembalikan data, serta penggunaan BottomNavigationBar.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }
}