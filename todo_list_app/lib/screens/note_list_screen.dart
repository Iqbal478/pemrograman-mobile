import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/note.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({Key? key}) : super(key: key);

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  List<Note> notes = [];

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  // ============================
  // LOAD & SAVE
  // ============================
  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesString = prefs.getString('notes');

    if (notesString != null) {
      final List<dynamic> decoded = jsonDecode(notesString);
      setState(() {
        notes = decoded
            .map((e) => Note.fromJson(e as Map<String, dynamic>))
            .toList();
      });
    }
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'notes',
      jsonEncode(notes.map((e) => e.toJson()).toList()),
    );
  }

  // ============================
  // CRUD
  // ============================
  void _addNote(String title, String content) {
    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      createdAt: DateTime.now(),
    );

    setState(() {
      notes.add(note);
    });

    _saveNotes();
  }

  void _updateNote(int index, String title, String content) {
    final updatedNote = notes[index].copyWith(
      title: title,
      content: content,
    );

    setState(() {
      notes[index] = updatedNote;
    });

    _saveNotes();
  }

  void _toggleDone(int index, bool value) {
    setState(() {
      notes[index].isDone = value;
    });
    _saveNotes();
  }

  void _deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
    });
    _saveNotes();
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  // ============================
  // UI
  // ============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD), // 💙 Soft blue
      appBar: AppBar(
        title: const Text('Todo List'),
        backgroundColor: Colors.blueAccent,
      ),

      body: notes.isEmpty ? _buildEmptyState() : _buildNoteList(),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue, // 💙 Blue FAB
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showNoteDialog(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'Belum ada catatan',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }

  // ============================
  // LIST NOTE ✔ Checkbox Work
  // ============================
  Widget _buildNoteList() {
    return ListView.builder(
      itemCount: notes.length,
      padding: const EdgeInsets.all(12),
      itemBuilder: (context, index) {
        final note = notes[index];

        return Card(
          color: const Color(0xFFFFF9C4), // 💛 Soft yellow
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          margin: const EdgeInsets.only(bottom: 12),

          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: note.isDone,
                  onChanged: (value) {
                    _toggleDone(index, value ?? false);
                  },
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          decoration: note.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: note.isDone ? Colors.grey : Colors.black,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        _formatDate(note.createdAt),
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.edit, size: 20, color: Colors.black54),
                  onPressed: () => _showNoteDialog(index: index),
                ),

                IconButton(
                  icon: const Icon(Icons.delete, size: 22, color: Colors.red),
                  onPressed: () => _showDeleteDialog(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================
  // DELETE DIALOG
  // ============================
  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Catatan'),
        content: Text('Hapus "${notes[index].title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              _deleteNote(index);
              Navigator.pop(context);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ============================
  // ADD / EDIT DIALOG
  // ============================
  void _showNoteDialog({int? index}) {
    final isEdit = index != null;

    titleController.text = isEdit ? notes[index!].title : "";
    contentController.text = isEdit ? notes[index].content : "";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Edit Catatan' : 'Tambah Catatan'),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Judul',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(
                labelText: 'Konten',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isEmpty ||
                  contentController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Judul & Konten tidak boleh kosong'),
                  ),
                );
                return;
              }

              if (isEdit) {
                _updateNote(index!, titleController.text, contentController.text);
              } else {
                _addNote(titleController.text, contentController.text);
              }

              Navigator.pop(context);
            },
            child: Text(isEdit ? 'Update' : 'Simpan'),
          ),
        ],
      ),
    );
  }
}
