// main.dart
import 'package:flutter/material.dart';
// Import yang benar untuk file tab
import 'package:flutter_navigation_demo/screens/TabsScreen.dart'; 

// Variabel global untuk Tema Material 3
const Color primaryColor = Color(0xFF006A6A);
const Color secondaryColor = Color(0xFF6BBA70);

void main() {
  runApp(const FlutterNavigationDemo());
}

class FlutterNavigationDemo extends StatelessWidget {
  const FlutterNavigationDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Nav Demo',
      // Menghapus teks debug di pojok kanan atas
      debugShowCheckedModeBanner: false,
      // Menggunakan Material 3 dengan ColorScheme kustom
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      // Halaman awal
      home: const MainScreen(),
    );
  }
}

// -----------------------------------------------------------
// HALAMAN 1: MainScreen (Menggunakan BottomNavigationBar)
// -----------------------------------------------------------

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Indeks halaman/tab yang saat ini dipilih
  int _selectedIndex = 0;

  // Daftar widget halaman/tab untuk BottomNavigationBar
  static final List<Widget> _widgetOptions = <Widget>[
    // Kelas TabA, TabB, TabC sekarang harus diimpor dari TabsScreen.dart
    const TabA(), // Tab Visual dengan Daftar Pesan
    const TabB(), // Tab Profil yang Dipercantik
    const TabC(), // Halaman Tentang Sederhana
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dinamis berdasarkan Tab yang dipilih
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? 'Pesan & Navigasi' : _selectedIndex == 1 ? 'Profil Pengguna' : 'Tentang Aplikasi',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        elevation: 1,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      
      // Implementasi BottomNavigationBar (Material 3 NavigationBar)
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.forum_outlined),
            selectedIcon: Icon(Icons.forum),
            label: 'Pesan',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_pin_outlined),
            selectedIcon: Icon(Icons.person_pin),
            label: 'Profil',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info),
            label: 'Info',
          ),
        ],
      ),
    );
  }
}