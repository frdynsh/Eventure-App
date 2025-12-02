import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'search_event_page.dart';
import 'my_schedule_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final ApiService _apiService = ApiService();

  // Daftar Halaman untuk Tab
  final List<Widget> _pages = [const SearchEventPage(), const MySchedulePage()];

  // Logika Logout
  void _doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    final int userId = prefs.getInt('userId') ?? 0;

    await _apiService.logout(userId); // Hapus token di server
    await prefs.clear(); // Hapus sesi di HP

    if (!mounted) return;

    // Kembali ke Login & Hapus history
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Berhasil Keluar")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? "Cari Konser" : "Jadwal Saya"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            tooltip: "Keluar",
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Konfirmasi"),
                  content: const Text("Yakin ingin keluar aplikasi?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("Batal"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _doLogout();
                      },
                      child: const Text(
                        "Keluar",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            label: 'Jadwal',
          ),
        ],
      ),
    );
  }
}
