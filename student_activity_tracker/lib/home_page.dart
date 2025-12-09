// lib/home_page.dart

import 'package:flutter/material.dart';
import 'model/activity_model.dart';
import 'activity_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Callback untuk memberitahu RootPage ketika data SharedPreferences selesai dimuat
typedef ActivitiesCallback = void Function(List<Activity> activities);

class HomePage extends StatefulWidget {
  final List<Activity> activities;
  final ActivitiesCallback onActivitiesLoaded; // Callback saat data dari pref dimuat
  final Function(String) onDelete;

  const HomePage({
    super.key,
    required this.activities,
    required this.onActivitiesLoaded,
    required this.onDelete,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFromPrefs();
  }

  // PENTING: Pemuatan data dari SharedPreferences
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList('activities') ?? [];
    final loadedActivities = raw.map((s) => Activity.fromJson(s)).toList();
    
    // Kirim data yang dimuat ke RootPage melalui callback
    widget.onActivitiesLoaded(loadedActivities);
    
    setState(() {
      _isLoading = false;
    });
  }
  
  // Fungsi delete yang memicu callback ke RootPage
  void _handleDelete(String id) {
    widget.onDelete(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Aktivitas dihapus ✅')));
  }

  void _openSearch() async {
    // Membuka fitur pencarian (SearchDelegate)
    final result = await showSearch<Activity?>(
      context: context, 
      delegate: ActivitySearchDelegate(widget.activities)
    );
    
    if (result != null) {
      // Navigasi ke detail aktivitas yang ditemukan. 
      // result dijamin non-null di sini.
      final res = await Navigator.push(
        context, 
        // Menggunakan 'result' tanpa tanda seru (!) karena sudah di-null check di 'if'
        MaterialPageRoute(builder: (_) => ActivityDetailPage(activity: result)) 
      );
      
      if (res == 'deleted') {
        _handleDelete(result.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Tampilan Loading (Diperbaiki untuk menghilangkan 'const' pada Scaffold)
    if (_isLoading) {
      return Scaffold( // Dihapus 'const'
        appBar: AppBar(title: const Text('Student Activity Tracker')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    // 2. Tampilan Utama
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Activity Tracker'),
        actions: [
          IconButton(
            onPressed: _openSearch, 
            icon: const Icon(Icons.search)
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding yang lebih konsisten
        child: Column(
          children: [
            // Card Statistik
            Card(
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.list_alt, size: 28),
                title: const Text('Daftar Aktivitas Anda'),
                subtitle: Text('${widget.activities.length} item tercatat'),
              ),
            ),
            const SizedBox(height: 16),
            
            // Daftar Aktivitas (ListView.builder)
            Expanded(
              child: widget.activities.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.event_note_outlined, size: 64, color: Colors.grey), 
                          SizedBox(height: 8), 
                          Text('Belum ada aktivitas. Yuk, tambahkan!'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: widget.activities.length,
                      itemBuilder: (context, index) {
                        final a = widget.activities[index];
                        return Card(
                          elevation: 1, 
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            onTap: () async {
                              // Navigasi ke Halaman Detail
                              final result = await Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (_) => ActivityDetailPage(activity: a))
                              );
                              if (result == 'deleted') {
                                _handleDelete(a.id);
                              }
                            },
                            title: Text(a.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text('${a.category} • ${a.duration} jam'),
                            trailing: Icon(
                              a.done ? Icons.check_circle : Icons.radio_button_unchecked, 
                              color: a.done ? Colors.green.shade600 : Colors.grey
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// SearchDelegate (Tidak ada perubahan, kode sudah benar)
class ActivitySearchDelegate extends SearchDelegate<Activity?> {
  final List<Activity> list;
  ActivitySearchDelegate(this.list);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = list.where((a) => a.name.toLowerCase().contains(query.toLowerCase()) || a.category.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final a = results[index];
        return ListTile(
          title: Text(a.name),
          subtitle: Text('${a.category} • ${a.duration} jam'),
          onTap: () => close(context, a),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = list.where((a) => a.name.toLowerCase().contains(query.toLowerCase()) || a.category.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final a = suggestions[index];
        return ListTile(
          title: Text(a.name),
          subtitle: Text(a.category),
          onTap: () {
            query = a.name;
            showResults(context);
          },
        );
      },
    );
  }
}