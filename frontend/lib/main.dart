import 'package:flutter/material.dart';
import 'ui/login_page.dart';
import 'ui/registrasi_page.dart';
import 'ui/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eventure App',
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login', 
      routes: {
        '/login': (context) => const LoginPage(), // Halaman Login
        '/registrasi': (context) => const RegistrasiPage(), // Halaman Daftar
        '/home': (context) => const HomePage(), // Halaman Utama (Cari & Jadwal)
      },
    );
  }
}
