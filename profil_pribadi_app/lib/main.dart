import 'package:flutter/material.dart';

// Import library ikon khusus (untuk logo sosial media)
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const MyApp());
}

// Mengubah dari StatelessWidget menjadi StatefulWidget untuk mengelola status halaman
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Biodata App',
      home: BiodataScreen(), // Menggunakan widget utama baru
    );
  }
}

// Widget utama yang menangani navigasi antar halaman (Page View)
class BiodataScreen extends StatelessWidget {
  const BiodataScreen({super.key});

  // Widget kustom untuk menampilkan setiap item biodata dalam sebuah kotak
  Widget _buildBiodataBox(String text) {
    return Container(
      // Dekorasi kotak (box)
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 246, 69, 69), // Warna Dark Grey
        borderRadius: BorderRadius.circular(10), // Sudut membulat
        boxShadow: [
          BoxShadow(
            color: (Colors.black87),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // Efek shadow
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      margin: const EdgeInsets.only(bottom: 15), // Jarak antar kotak
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Warna font Putih
          // Menambahkan efek shadow pada teks (opsional, untuk memperkuat)
          shadows: [
            Shadow(
              blurRadius: 5.0,
              color: (Colors.black87),
              offset: const Offset(1.0, 1.0),
            ),
          ],
        ),
      ),
    );
  }

  // Widget baru untuk menampilkan ikon sosial media di footer
  Widget _buildSocialIconFooter() {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ikon Email
          IconButton(
            icon: const Icon(Icons.email, color: Colors.blueGrey, size: 30),
            onPressed: () {
              // Tambahkan fungsi untuk membuka email client di sini
            },
          ),
          const SizedBox(width: 20),
          // Ikon Facebook (menggunakan FontAwesomeIcons)
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.squareFacebook,
                color: Colors.blue, size: 30),
            onPressed: () {},
          ),
          const SizedBox(width: 20),
          // Ikon Instagram
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.instagram,
                color: Colors.pink, size: 30),
            onPressed: () {},
          ),
          const SizedBox(width: 20),
          // Ikon WhatsApp
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.whatsapp,
                color: Colors.green, size: 30),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // --- Halaman 1: Biodata Utama ---
  Widget _buildPageOne(BuildContext context) {
    return Container(
      // Latar belakang body berwarna Cream
      color: const Color.fromARGB(255, 220, 220, 111),
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView( // Menggunakan SingleChildScrollView agar bisa digulir
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. FOTO (Square, 1:1)
            Center(
              child: Container(
                width: 150, // Ukuran lebar foto
                height: 150, // Ukuran tinggi foto (membuat 1:1/Square)
                margin: const EdgeInsets.only(bottom: 25),
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // Membuat foto berbentuk lingkaran
                  border: Border.all(color: Colors.black45, width: 3),
                  image: const DecorationImage(
                    // Ganti URL ini dengan URL foto Anda
                    image: AssetImage(
                        'assets/images/Ganteng.jpg'), // <--- LOKASI PENTING
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(128),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
              ),
            ),

            // 2. BIODATA (Kotak lama yang sudah dikustomisasi)
            _buildBiodataBox("Nama : M.iqbal"),
            _buildBiodataBox("Nim : 701230046"),
            _buildBiodataBox("Hobi : badminton dan olahraga"),

            // 3. FOOTER IKON SOSIAL
            _buildSocialIconFooter(),
          ],
        ),
      ),
    );
  }

  // --- Halaman 2: Biografi Singkat ---
  Widget _buildPageTwo(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 220, 220, 111),
      padding: const EdgeInsets.all(25),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Biografi Singkat",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 51, 51, 51)),
            ),
            const Divider(height: 30, thickness: 2, color: Colors.black38),

            // Widget Menarik: Card Timeline
            _buildInterestingWidget(
              icon: Icons.school,
              title: "Pendidikan",
              content:
              "Dengan performa akademik yang unggul secara berkelanjutan dari SD hingga SMA, saya telah membentuk bekal kuat yang siap menunjang kesuksesan studi saya ke depan.",
            ),
            _buildInterestingWidget(
              icon: Icons.movie,
              title: "Hobi",
              content:
              "Di luar akademik, saya telah serius menekuni musik (Gitar dan Keyboard) sejak SMP dan aktif bermain sepak bola. Minat saya pada teknologi mulai berkembang pesat setelah mengambil jurusan Multimedia di SMK, dan kini menjadi fokus utama saya.",
            ),
            _buildInterestingWidget(
              icon: Icons.computer,
              title: "Sistem Informasi",
              content:
              "Memilih teknologi adalah langkah cerdas. Ini adalah titik temu di mana logika Anda menjadi fondasi, dan kreativitas menjadi motor penggerak, menyiapkan Anda secara langsung untuk karir inovatif yang sangat relevan di masa depan.",
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Tambahkan fungsi navigasi kembali jika perlu
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text("Geser untuk kembali"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget kustom untuk item biografi (menarik)
  Widget _buildInterestingWidget({required IconData icon, required String title, required String content}) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.deepOrange, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 15, color: Colors.black12),
            Text(
              content,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Biodata App",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          backgroundColor: Colors.lightBlue[100],
          elevation: 4,
        ),
        body: PageView(
          // PageView memungkinkan pengguna menggeser antar halaman
            children: <Widget>[
              _buildPageOne(context), // Halaman 1: Biodata Utama
              _buildPageTwo(context), // Halaman 2: Biografi Singkat
            ],
            ),
        );
    }
}