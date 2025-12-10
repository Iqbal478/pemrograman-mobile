import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

// ---------------------------------------------------------
// 1. Model Data
// ---------------------------------------------------------
class Note {
  String title;
  String content;
  DateTime date;
  String category;

  Note({
    required this.title,
    required this.content,
    required this.date,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'category': category,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      title: map['title'],
      content: map['content'],
      date: DateTime.parse(map['date']),
      category: map['category'],
    );
  }
}

// ---------------------------------------------------------
// Root App
// ---------------------------------------------------------
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _toggleTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catatan Tugas Mahasiswa',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      home: HomePage(onThemeChanged: _toggleTheme, isDarkMode: _themeMode == ThemeMode.dark),
    );
  }
}

// ---------------------------------------------------------
// Halaman Utama (Home Page)
// ---------------------------------------------------------
class HomePage extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  const HomePage({super.key, required this.onThemeChanged, required this.isDarkMode});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> allNotes = [];
  String selectedFilter = 'Semua';
  final List<String> categories = ['Kuliah', 'Organisasi', 'Pribadi', 'Lain-lain'];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesString = prefs.getString('notes_data');
    if (notesString != null) {
      List<dynamic> jsonList = jsonDecode(notesString);
      setState(() {
        allNotes = jsonList.map((e) => Note.fromMap(e)).toList();
      });
    }
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> jsonList = allNotes.map((e) => e.toMap()).toList();
    await prefs.setString('notes_data', jsonEncode(jsonList));
  }

  // Fungsi Menghapus Data (Dipanggil setelah konfirmasi OK)
  void _deleteNote(Note note) {
    setState(() {
      allNotes.remove(note);
    });
    _saveNotes();
    
    // Opsional: Tampilkan SnackBar kecil di bawah sebagai feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Catatan berhasil dihapus'), duration: Duration(seconds: 2)),
    );
  }

  // ------------------------------------------------------------------------
  // FITUR BARU: Dialog Konfirmasi Hapus
  // ------------------------------------------------------------------------
  void _showDeleteConfirmationDialog(Note note) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Hapus Catatan"),
          content: Text("Apakah Anda yakin ingin menghapus catatan '${note.title}'?"),
          actions: [
            // Tombol Batal
            TextButton(
              child: const Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog saja
              },
            ),
            // Tombol Hapus
            TextButton(
              child: const Text("Hapus", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog dulu
                _deleteNote(note); // Baru jalankan fungsi hapus
              },
            ),
          ],
        );
      },
    );
  }

  // Fungsi Pindah ke Halaman Edit
  void _navigateToEditPage(Note note) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteFormPage(note: note),
      ),
    );

    if (result != null && result is Note) {
      setState(() {
        int indexInAllNotes = allNotes.indexOf(note);
        if (indexInAllNotes != -1) {
          allNotes[indexInAllNotes] = result; 
        }
      });
      _saveNotes();
    }
  }

  IconData _getIconByCategory(String category) {
    switch (category) {
      case 'Kuliah': return Icons.school;
      case 'Organisasi': return Icons.people;
      case 'Pribadi': return Icons.home;
      default: return Icons.auto_awesome;
    }
  }

  Color _getColorByCategory(String category) {
    switch (category) {
      case 'Kuliah': return Colors.blue;
      case 'Organisasi': return Colors.orange;
      case 'Pribadi': return Colors.green;
      default: return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Note> filteredNotes = selectedFilter == 'Semua'
        ? allNotes
        : allNotes.where((note) => note.category == selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Tugas'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => widget.onThemeChanged(!widget.isDarkMode),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Filter Kategori',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.filter_list),
              ),
              value: selectedFilter,
              items: ['Semua', ...categories].map((String category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedFilter = value!;
                });
              },
            ),
          ),
          
          Expanded(
            child: filteredNotes.isEmpty
                ? const Center(child: Text("Belum ada catatan"))
                : ListView.builder(
                    itemCount: filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = filteredNotes[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getColorByCategory(note.category).withOpacity(0.2),
                            child: Icon(_getIconByCategory(note.category), color: _getColorByCategory(note.category)),
                          ),
                          title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(note.content, maxLines: 1, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    DateFormat('dd MMM yyyy').format(note.date),
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: _getColorByCategory(note.category).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4)
                                    ),
                                    child: Text(note.category, style: TextStyle(fontSize: 10, color: _getColorByCategory(note.category))),
                                  )
                                ],
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _navigateToEditPage(note),
                                tooltip: 'Edit',
                              ),
                              // Tombol Hapus dengan Konfirmasi
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                // SEKARANG MANGGIL FUNGSI DIALOG, BUKAN LANGSUNG DELETE
                                onPressed: () => _showDeleteConfirmationDialog(note), 
                                tooltip: 'Hapus',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NoteFormPage()),
          );

          if (result != null && result is Note) {
            setState(() {
              allNotes.add(result);
            });
            _saveNotes();
          }
        },
      ),
    );
  }
}

// ---------------------------------------------------------
// Halaman Form Tambah / Edit Catatan
// ---------------------------------------------------------
class NoteFormPage extends StatefulWidget {
  final Note? note; 

  const NoteFormPage({super.key, this.note});

  @override
  State<NoteFormPage> createState() => _NoteFormPageState();
}

class _NoteFormPageState extends State<NoteFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  String _selectedCategory = 'Kuliah';

  final List<String> categories = ['Kuliah', 'Organisasi', 'Pribadi', 'Lain-lain'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    
    if (widget.note != null) {
      _selectedCategory = widget.note!.category;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note != null ? 'Edit Catatan' : 'Tambah Catatan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Tugas',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Judul tidak boleh kosong';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Tugas',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Deskripsi tidak boleh kosong';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                items: categories.map((String category) {
                  return DropdownMenuItem(value: category, child: Text(category));
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newNote = Note(
                        title: _titleController.text,
                        content: _contentController.text,
                        date: widget.note?.date ?? DateTime.now(), 
                        category: _selectedCategory,
                      );

                      Navigator.pop(context, newNote);
                    }
                  },
                  child: Text(widget.note != null ? 'Simpan Perubahan' : 'Simpan Catatan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}