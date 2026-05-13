import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(FlashAIApp());
}

class FlashAIApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlashAI',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: HomeScreen(), // Membuka halaman utama yang kita buat
    );
  }
}