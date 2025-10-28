import 'package:flutter/material.dart';
import 'navbar.dart'; // Import navbar yang sudah dibuat

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Channel App',
      debugShowCheckedModeBanner: false, // Hilangkan banner debug
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B4AE2)),
        useMaterial3: true,
      ),
      home: const NavBar(), // Langsung panggil NavBar sebagai home
    );
  }
}
