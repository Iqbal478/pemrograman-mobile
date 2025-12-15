import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/recipe_model.dart';
import '../models/note_model.dart';
import '../providers/recipe_provider.dart';

class DetailScreen extends StatefulWidget {
  final Recipe recipe;
  const DetailScreen({super.key, required this.recipe});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<RecipeProvider>(context, listen: false).loadNotes(widget.recipe.id);
  }

  // 1. Dialog Tambah/Edit
  void _showNoteDialog(BuildContext context, {Note? note}) {
    final isEdit = note != null;
    if (isEdit) {
      _noteController.text = note.content;
    } else {
      _noteController.clear();
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEdit ? 'Edit Catatan' : 'Tambah Catatan'),
        content: TextField(
          controller: _noteController,
          decoration: const InputDecoration(
            hintText: 'Tulis catatanmu disini...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (_noteController.text.isNotEmpty) {
                final provider = Provider.of<RecipeProvider>(context, listen: false);
                
                if (isEdit) {
                  // Update
                  final updatedNote = Note(
                    id: note.id,
                    recipeId: note.recipeId,
                    content: _noteController.text,
                  );
                  provider.updateNote(updatedNote);
                } else {
                  // Create
                  provider.addNote(widget.recipe.id, _noteController.text);
                }
                
                Navigator.pop(ctx);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // 2. Dialog Konfirmasi Hapus (FITUR BARU)
  void _confirmDelete(BuildContext context, int noteId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Catatan?"),
        content: const Text("Apakah Anda yakin ingin menghapus catatan ini? Data tidak bisa dikembalikan."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), // Tutup dialog
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Warna merah tanda bahaya
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              // Hapus Data
              Provider.of<RecipeProvider>(context, listen: false)
                  .deleteNote(noteId, widget.recipe.id);
              Navigator.pop(ctx); // Tutup dialog setelah hapus
              
              // Tampilkan notifikasi kecil di bawah (SnackBar)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Catatan berhasil dihapus"), duration: Duration(seconds: 1)),
              );
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecipeProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // === HEADER GAMBAR (Parallax) ===
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            backgroundColor: Colors.orange,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.recipe.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 10)],
                ),
              ),
              background: Hero(
                tag: widget.recipe.id,
                child: Image.network(
                  widget.recipe.thumb,
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(0.2),
                  colorBlendMode: BlendMode.darken,
                ),
              ),
            ),
          ),

          // === ISI KONTEN ===
          SliverToBoxAdapter(
            child: Container(
              transform: Matrix4.translationValues(0.0, -20.0, 0.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  // --- TEKS DUMMY ---
                  const Row(
                    children: [
                      Icon(Icons.timer, color: Colors.orange, size: 20),
                      SizedBox(width: 5),
                      Text("45 Menit  •  Mudah  •  2 Porsi", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text("Deskripsi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    "Hidangan ${widget.recipe.name} ini adalah pilihan sempurna untuk makan malam spesial. Menggunakan bahan-bahan segar berkualitas tinggi.",
                    style: TextStyle(color: Colors.grey[700], height: 1.5),
                  ),
                  
                  const Divider(height: 40, thickness: 1),

                  // --- BAGIAN CRUD CATATAN ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Catatan Koki",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text("Tambah"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[50],
                          foregroundColor: Colors.orange[800],
                          elevation: 0,
                        ),
                        onPressed: () => _showNoteDialog(context),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),

                  // LIST CATATAN (READ)
                  provider.currentNotes.isEmpty
                      ? Container(
                          height: 100,
                          alignment: Alignment.center,
                          child: const Text("Belum ada catatan masak.", style: TextStyle(color: Colors.grey)),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: provider.currentNotes.length,
                          itemBuilder: (ctx, i) {
                            final note = provider.currentNotes[i];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              color: const Color(0xFFFFF9C4), // Warna Sticky Note
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      note.content,
                                      style: GoogleFonts.kalam(fontSize: 16, height: 1.3),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // TOMBOL EDIT
                                        InkWell(
                                          onTap: () => _showNoteDialog(context, note: note),
                                          child: const Icon(Icons.edit, color: Colors.blue, size: 20),
                                        ),
                                        const SizedBox(width: 15),
                                        
                                        // TOMBOL HAPUS (DENGAN KONFIRMASI)
                                        InkWell(
                                          onTap: () => _confirmDelete(context, note.id!), // <--- Panggil Dialog Disini
                                          child: const Icon(Icons.delete, color: Colors.red, size: 20),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}