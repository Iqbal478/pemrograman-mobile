// screens/details.dart
import 'package:flutter/material.dart';

// -----------------------------------------------------------
// HALAMAN 2: DetailScreen (Menerima Data & Menunggu Hasil Pop)
// -----------------------------------------------------------

class DetailScreen extends StatefulWidget {
  // Data yang diterima dari halaman sebelumnya (push)
  final String message;
  final String senderName;
  final String senderAvatar;

  const DetailScreen({
    super.key,
    required this.message,
    required this.senderName,
    required this.senderAvatar,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String _returnedData = 'Belum ada balasan yang dikirim.';

  // Fungsi untuk navigasi dan menunggu hasil pop
  Future<void> _navigateAndAwaitResult() async {
    // Navigator.push() di-await untuk menangkap hasil dari Navigator.pop()
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DataSenderScreen(recipient: widget.senderName),
      ),
    );

    // Memperbarui state dengan hasil yang dikembalikan
    if (result != null && result is String) {
      setState(() {
        _returnedData = 'Balasan berhasil dikirim: "$result"';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pesan'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Kartu Informasi Pengirim dan Pesan
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Avatar Pengirim
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: colorScheme.onPrimaryContainer,
                        foregroundColor: colorScheme.primaryContainer,
                        child: Text(widget.senderAvatar, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Dari: ${widget.senderName}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorScheme.onPrimaryContainer),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Pesan Diterima (Data Push):',
                        style: TextStyle(fontSize: 14, color: colorScheme.onPrimaryContainer.withOpacity(0.7)),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: colorScheme.outlineVariant),
                        ),
                        child: Text(
                          widget.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Bagian Hasil Balasan (Data Pop)
              Text(
                'Status Balasan (Data Pop):',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colorScheme.secondary),
              ),
              const SizedBox(height: 8),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _returnedData,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: colorScheme.onSecondaryContainer),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Tombol Aksi
              ElevatedButton.icon(
                icon: const Icon(Icons.reply_all),
                label: const Text('Balas Pesan (Navigator.push & Await Pop)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondary,
                  foregroundColor: colorScheme.onSecondary,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _navigateAndAwaitResult,
              ),
              const SizedBox(height: 15),
              OutlinedButton.icon(
                icon: const Icon(Icons.arrow_back_ios_new),
                label: const Text('Selesai & Kembali ke Daftar Pesan (Navigator.pop)'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.outline,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  side: BorderSide(color: colorScheme.outline),
                ),
                onPressed: () {
                  // Navigator.pop() untuk kembali ke halaman sebelumnya
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------
// HALAMAN 3: DataSenderScreen (Mengembalikan Data)
// -----------------------------------------------------------

class DataSenderScreen extends StatefulWidget {
  final String recipient;
  const DataSenderScreen({super.key, required this.recipient});

  @override
  State<DataSenderScreen> createState() => _DataSenderScreenState();
}

class _DataSenderScreenState extends State<DataSenderScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Kirim Balasan ke ${widget.recipient}'),
        backgroundColor: colorScheme.tertiary,
        foregroundColor: colorScheme.onTertiary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Masukkan balasan Anda di bawah. Pesan ini akan dikembalikan ke Halaman Detail menggunakan Navigator.pop()',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _controller,
              minLines: 5,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Tulis balasan Anda di sini...',
                labelText: 'Isi Balasan',
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                filled: true,
                fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.send_rounded),
              label: const Text('Kirim Balasan (Navigator.pop)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.tertiary,
                foregroundColor: colorScheme.onTertiary,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                // Navigator.pop() MENGEMBALIKAN DATA
                String result = _controller.text.isEmpty
                    ? 'Balasan Otomatis: Terima kasih atas pesan Anda.'
                    : _controller.text;
                // Mengembalikan data string ke DetailScreen
                Navigator.pop(context, result);
              },
            ),
            const SizedBox(height: 15),
            TextButton.icon(
              icon: const Icon(Icons.close),
              label: const Text('Batal Kirim'),
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.error,
              ),
              onPressed: () {
                // Kembali tanpa mengembalikan data spesifik (mengembalikan null)
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}