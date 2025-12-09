// lib/main.dart (Kode sudah diperbaiki)

import 'package:flutter/material.dart';
import 'home_page.dart';
import 'add_activity_page.dart';
import 'profile_page.dart';
import 'model/activity_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // Pastikan binding diinisialisasi sebelum mengakses SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('isDarkMode') ?? false;
  runApp(MyApp(isDark: isDark));
}

class MyApp extends StatefulWidget {
  final bool isDark;
  const MyApp({super.key, required this.isDark});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    _isDark = widget.isDark;
  }

  void _toggleTheme(bool v) async {
    setState(() => _isDark = v);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', v);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Activity Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Warna cerah untuk mode terang
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 255, 17), brightness: Brightness.light),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        // Warna yang sama namun skema gelap untuk mode gelap
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 51, 255), brightness: Brightness.dark),
      ),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: RootPage(onThemeChanged: _toggleTheme, isDark: _isDark),
    );
  }
}

class RootPage extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDark;
  const RootPage({super.key, required this.onThemeChanged, required this.isDark});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _index = 0;
  List<Activity> _activities = [];

  void _setActivities(List<Activity> list) {
    // Dipanggil oleh HomePage saat data dari SharedPreferences selesai dimuat
    setState(() => _activities = list);
  }

  Future<void> _saveActivities() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('activities', _activities.map((a) => a.toJson()).toList());
  }

  void _removeActivityById(String id) {
    setState(() => _activities.removeWhere((e) => e.id == id));
    _saveActivities(); // Panggil fungsi save async yang sudah diperbaiki
  }

  // Halaman Tambah Aktivitas sekarang menggunakan Navigator.push
  void _navigateToAddActivity(BuildContext context) async {
    final newActivity = await Navigator.push<Activity>(context, MaterialPageRoute(builder: (_) => const AddActivityPage()));
    
    if (newActivity != null) {
      setState(() => _activities.add(newActivity));
      
      // Menggunakan await untuk penyimpanan data (Best Practice)
      await _saveActivities(); 
      
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Aktivitas ditambahkan')));
      
      // Setelah menambahkan, arahkan ke Home
      setState(() => _index = 0);
    }
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return HomePage(
          activities: _activities,
          onActivitiesLoaded: _setActivities, // Untuk memuat data awal
          onDelete: _removeActivityById,      // Untuk menghapus data
        );
      case 1:
        // Tab Add: Seharusnya tidak pernah tampil, karena navigasi sudah di handle di onTap.
        // Jika sampai sini, tampilkan placeholder agar tidak error.
        return const Center(child: Text('Navigasi ke Tambah Aktivitas...')); 
      case 2:
        return ProfilePage(onThemeChanged: widget.onThemeChanged, isDark: widget.isDark);
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(_index),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) {
          if (i == 1) {
            // Ketika tombol 'Add' ditekan, panggil fungsi navigasi
            _navigateToAddActivity(context);
          } else {
            // Untuk tab Home (0) dan Profile (2), ubah index state
            setState(() => _index = i);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}