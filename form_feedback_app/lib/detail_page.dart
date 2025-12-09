import 'package:flutter/material.dart';
import 'feedback_form_page.dart';

// =========================================================================
// Halaman 2: Ringkasan Feedback (Ultimate Modern UI)
// =========================================================================

class DetailPage extends StatefulWidget {
  final FeedbackData feedback;

  const DetailPage({super.key, required this.feedback});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  // Warna Konsisten
  static const Color primaryDeepBlue = Color(0xFF1A237E); // Primary
  static const Color primaryLightBlue = Color(0xFF5C6BC0); // Light Primary
  // Variabel 'accentCyan' dihapus karena tidak digunakan.
  static const Color backgroundSilver = Color(0xFFF0F4F8); // Background

  @override
  void initState() {
    super.initState();
    // Animasi Bounce In pada ikon saat dimuat
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    // Animasi untuk scaling: memantul sedikit lalu stabil
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.15), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 0.95), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.0), weight: 30),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Fungsi Logika untuk mengubah Ikon dan Pesan
  Map<String, dynamic> _getFeedbackVisuals(int rating) {
    if (rating >= 4) {
      return {
        'icon': Icons.rocket_launch_rounded,
        'message': 'SANGAT PUAS',
        'sub_message': 'Pengalaman Anda luar biasa! Lanjutkan.',
        'color': const Color(0xFF00C853), // Green Accent
        'icon_color': Colors.white,
      };
    } else if (rating == 3) {
      return {
        'icon': Icons.waving_hand_rounded,
        'message': 'CUKUP PUAS',
        'sub_message': 'Kami akan terus tingkatkan layanan demi Anda.',
        'color': const Color(0xFFFFB300), // Gold/Amber
        'icon_color': Colors.white,
      };
    } else {
      return {
        'icon': Icons.sentiment_dissatisfied_rounded,
        'message': 'KURANG PUAS',
        'sub_message': 'Kami mohon maaf. Kami akan perbaiki kekurangan ini.',
        'color': const Color(0xFFD32F2F), // Dark Red
        'icon_color': Colors.white,
      };
    }
  }

  // Widget untuk menampilkan bintang rating
  Widget _buildRatingStars(int rating, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Icon(
          Icons.star_rounded,
          color: index < rating ? color : Colors.grey.shade300,
          size: 40,
        );
      }),
    );
  }

  // Widget helper untuk item detail dengan ikon di card (Clean Design)
  Widget _buildResultItem({required String label, required String value, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primaryLightBlue, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: primaryDeepBlue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visuals = _getFeedbackVisuals(widget.feedback.rating);
    final Color headerColor = visuals['color'];
    final Color ratingColor = headerColor;

    // Nilai opasitas yang dikonversi dari 0.4 menjadi nilai alpha (0-255)
    final int alphaValue = (255 * 0.4).round();

    return Scaffold(
      backgroundColor: backgroundSilver,
      appBar: AppBar(
        title: const Text('Ringkasan Feedback'),
        backgroundColor: primaryDeepBlue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // CARD 1: HEADER DINAMIS dengan Gradien dan Animasi
            ScaleTransition(
              scale: _bounceAnimation,
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      // PERBAIKAN: Mengganti withOpacity()
                      color: headerColor.withAlpha(alphaValue),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  gradient: LinearGradient(
                    // PERBAIKAN: Mengganti withOpacity()
                    colors: [headerColor.withAlpha((255 * 0.9).round()), headerColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      visuals['icon'],
                      color: visuals['icon_color'],
                      size: 65,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      visuals['message'],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      visuals['sub_message'],
                      style: TextStyle(
                        // PERBAIKAN: Mengganti withOpacity()
                        color: Colors.white.withAlpha((255 * 0.8).round()),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // CARD 2: DETAIL RATING
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    // PERBAIKAN: Mengganti withOpacity()
                    color: Colors.grey.withAlpha((255 * 0.1).round()),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "Penilaian Anda:",
                    style: TextStyle(fontSize: 18, color: primaryDeepBlue, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  _buildRatingStars(widget.feedback.rating, ratingColor),
                  const SizedBox(height: 10),
                  Text(
                    '${widget.feedback.rating}/5',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: ratingColor,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // CARD 3: DETAIL INPUT (Nama & Komentar)
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    // PERBAIKAN: Mengganti withOpacity()
                    color: Colors.grey.withAlpha((255 * 0.1).round()),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Rincian Masukan:",
                    style: TextStyle(fontSize: 18, color: primaryDeepBlue, fontWeight: FontWeight.bold),
                  ),
                  const Divider(thickness: 1, height: 30, color: Colors.black12),
                  _buildResultItem(
                    label: 'Nama Pelanggan',
                    value: widget.feedback.name,
                    icon: Icons.person_outline_rounded,
                  ),
                  _buildResultItem(
                    label: 'Komentar/Saran',
                    value: widget.feedback.comment,
                    icon: Icons.forum_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Tombol kembali (Desain Accent)
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              label: const Text('KEMBALI KE FORMULIR'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryDeepBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.symmetric(vertical: 18),
                elevation: 10,
                // PERBAIKAN: Mengganti withOpacity()
                shadowColor: primaryDeepBlue.withAlpha((255 * 0.5).round()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}