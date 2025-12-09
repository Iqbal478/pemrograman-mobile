// lib/detail_screen.dart

import 'package:flutter/material.dart';
import 'main.dart';

class DetailScreen extends StatelessWidget {
  final Dosen dosen;
  const DetailScreen({super.key, required this.dosen});

  Widget _buildDetailCard({required IconData icon, required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.blueGrey, width: 0.5),
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.blueAccent, size: 30),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              content,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ),
          contentPadding: const EdgeInsets.all(15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Dosen'),
        backgroundColor: Colors.blueAccent.shade700,
        elevation: 0,
      ),
      // SingleChildScrollView untuk responsif
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Bagian Foto, Nama, dan NIDN
            Center(
              child: Column(
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 7,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.network(
                        dosen.fotoUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.person_pin, size: 100, color: Colors.grey);
                        },
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 15),
                  Text(
                    dosen.nama,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'NIDN: ${dosen.nidn}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Divider(color: Colors.blueGrey.shade200),
                  ),
                ],
              ),
            ),

            // Bagian Informasi Detail
            const Text(
              'Informasi Akademik & Kontak:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 10),

            _buildDetailCard(icon: Icons.lightbulb_outline, title: 'Bidang Keahlian', content: dosen.bidangKeahlian),
            _buildDetailCard(icon: Icons.email_outlined, title: 'Email Kontak', content: dosen.email),
            _buildDetailCard(icon: Icons.info_outline, title: 'Deskripsi Singkat', content: dosen.deskripsiSingkat),
            _buildDetailCard(icon: Icons.school_outlined, title: 'Riwayat Pendidikan', content: dosen.riwayatPendidikan),
          ],
        ),
      ),
    );
  }
}