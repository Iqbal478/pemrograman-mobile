// lib/home_screen.dart

import 'package:flutter/material.dart';
import 'main.dart';
import 'detail_screen.dart'; 

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Dosen Kampus', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.blueAccent.shade700,
        elevation: 4,
      ),
      body: ListView.builder(
        itemCount: daftarDosen.length,
        itemBuilder: (context, index) {
          final dosen = daftarDosen[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            // Menggunakan Card
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: InkWell( 
                onTap: () {
                  // Menggunakan Navigator.push untuk ke Halaman Detail
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(dosen: dosen),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(dosen.fotoUrl),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              dosen.nama,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dosen.bidangKeahlian,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                                fontStyle: FontStyle.italic,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey, size: 24),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}