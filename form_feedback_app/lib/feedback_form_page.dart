import 'package:flutter/material.dart';
import 'detail_page.dart';

// Model data tetap sama
class FeedbackData {
  final String name;
  final String comment;
  final int rating;

  FeedbackData({
    required this.name,
    required this.comment,
    required this.rating,
  });
}

// =========================================================================
// Halaman 1: Formulir Feedback (StatefulWidget)
// =========================================================================

class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  int _currentRating = 5; // Default rating 5 (Bintang Penuh)
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      final feedback = FeedbackData(
        name: _nameController.text,
        comment: _commentController.text,
        rating: _currentRating,
      );

      // Pindah ke Halaman Hasil (DetailPage)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailPage(feedback: feedback)),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  // Custom Widget untuk memilih Rating (Elegan)
  Widget _buildRatingSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kepuasan Anda:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 157, 52, 66),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(5, (index) {
            final ratingValue = index + 1;
            return GestureDetector(
              onTap: () {
                // Memperbarui UI secara real-time menggunakan setState()
                setState(() {
                  _currentRating = ratingValue;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _currentRating == ratingValue
                      ? const Color.fromARGB(255, 210, 37, 46) // Warna saat dipilih
                      : Colors.blueGrey.shade100, // Warna latar belakang
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _currentRating == ratingValue
                        ? const Color.fromARGB(255, 212, 210, 70)
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: _currentRating == ratingValue
                          ? Colors.white
                          : Colors.amber,
                      size: 30,
                    ),
                    Text(
                      '$ratingValue',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _currentRating == ratingValue
                            ? Colors.white
                            : const Color.fromARGB(255, 199, 181, 64),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulir Feedback Pelanggan')),
      // Menggunakan PageStorageKey untuk scroll yang lebih baik saat input
      body: SingleChildScrollView(
        key: const PageStorageKey<String>('feedbackForm'),
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Judul Elegan
              const Text(
                "Kami menghargai masukan Anda!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A237E),
                ),
              ),
              const SizedBox(height: 25),

              // Input Nama
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Anda',
                  hintText: 'Cth: Budi Santoso',
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: Color(0xFF1A237E),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama harus diisi.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Input Komentar
              TextFormField(
                controller: _commentController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Komentar & Saran',
                  hintText: 'Tuliskan pengalaman atau saran Anda...',
                  prefixIcon: Icon(
                    Icons.rate_review_outlined,
                    color: Color(0xFF1A237E),
                  ),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Komentar harus diisi.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Rating Selector Keren
              _buildRatingSelector(),

              const SizedBox(height: 40),

              // Tombol Submit
              ElevatedButton.icon(
                onPressed: _submitFeedback,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Kirim Feedback'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Placeholder untuk HomePage
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const FeedbackFormPage();
  }
}
