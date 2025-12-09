// lib/add_activity_page.dart

import 'package:flutter/material.dart';
import 'model/activity_model.dart'; // Memastikan Activity model diimpor

class AddActivityPage extends StatefulWidget {
  // Halaman ini tidak lagi menerima callback, hanya mengembalikan data melalui Navigator.pop
  const AddActivityPage({super.key}); 

  @override
  State<AddActivityPage> createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  
  // State untuk komponen interaktif
  String _category = 'Belajar';
  double _duration = 1;
  bool _done = false;
  
  final List<String> _categories = ['Belajar', 'Ibadah', 'Olahraga', 'Hiburan', 'Lainnya'];
  // final _formKey = GlobalKey<FormState>(); // Dihapus karena validasi dilakukan secara manual, bukan via Form

  @override
  void dispose() {
    // Penting untuk membuang controller setelah widget dibuang
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    
    // --- Validasi (Sesuai Spesifikasi) ---
    if (name.isEmpty) {
      showDialog(
        context: context, 
        builder: (_) => AlertDialog(
          title: const Text('Kesalahan ⚠️'), 
          content: const Text('Nama aktivitas wajib diisi.'), 
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: const Text('OK')
            )
          ]
        )
      );
      return;
    }

    // --- Pembuatan Objek Aktivitas ---
    final activity = Activity(
      // ID unik berdasarkan waktu
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      category: _category,
      duration: _duration.toInt(),
      done: _done,
      notes: _notesController.text.trim(),
    );

    // Kirim objek Activity kembali ke RootPage
    Navigator.pop(context, activity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Aktivitas Baru')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Pembungkus Form (Opsional, tapi praktik yang baik)
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              // 1. TextField Nama Aktivitas (Wajib)
              TextField(
                controller: _nameController, 
                decoration: const InputDecoration(
                  labelText: 'Nama Aktivitas', 
                  border: OutlineInputBorder(), 
                  hintText: 'Misal: Belajar Flutter 💻'
                )
              ),
              const SizedBox(height: 16),
              
              // 2. DropdownButtonFormField Kategori
              DropdownButtonFormField<String>(
                value: _category, 
                decoration: const InputDecoration(
                  labelText: 'Kategori Aktivitas', 
                  border: OutlineInputBorder()
                ), 
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(), 
                onChanged: (v) => setState(() => _category = v ?? _category)
              ),
              const SizedBox(height: 16),
              
              // 3. Slider Durasi
              const Text('Durasi (Jam) ⏱️', style: TextStyle(fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.only(top: 8.0), 
                child: Text('${_duration.toInt()} jam', style: const TextStyle(fontWeight: FontWeight.w500))
              ),
              Slider(
                min: 1, 
                max: 8, 
                divisions: 7, 
                value: _duration, 
                label: '${_duration.toInt()} jam', 
                onChanged: (v) => setState(() => _duration = v)
              ),
              
              // 4. SwitchListTile Status
              SwitchListTile(
                title: const Text('Status: Sudah Selesai ✅'), 
                value: _done, 
                onChanged: (v) => setState(() => _done = v), 
                contentPadding: EdgeInsets.zero
              ),
              const SizedBox(height: 16),
              
              // 5. TextField Catatan Tambahan (Optional)
              TextField(
                controller: _notesController, 
                decoration: const InputDecoration(
                  labelText: 'Catatan Tambahan (Opsional) 📝', 
                  border: OutlineInputBorder()
                ), 
                maxLines: 4
              ),
              const SizedBox(height: 24),
              
              // 6. Tombol Simpan
              SizedBox(
                width: double.infinity, 
                height: 50, 
                child: ElevatedButton(
                  onPressed: _save, 
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                  ), 
                  child: const Text('Simpan Aktivitas', style: TextStyle(fontSize: 16)))
              ),
            ]),
        ),
      ),
    );
  }
}