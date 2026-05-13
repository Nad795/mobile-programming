import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Pastikan ini ada
import 'screens/home_screen.dart';

Future<void> main() async {
  // 1. Pastikan binding Flutter sudah siap
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Tunggu sampai file .env benar-benar selesai dimuat
  await dotenv.load(fileName: ".env");
  
  // 3. Baru jalankan aplikasi
  runApp(FlashAIApp());
}

class FlashAIApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlashAI',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: HomeScreen(),
    );
  }
}