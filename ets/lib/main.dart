import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'services/firebase_options.dart';

import 'package:ets/screens/home.dart';
import 'package:ets/screens/login.dart';
import 'package:ets/screens/register.dart';
import 'package:ets/screens/notes.dart';
import 'package:ets/screens/chat.dart';
import 'package:ets/screens/gallery.dart';
import 'package:ets/screens/camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions
            .currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false,

      title: "GamePhone",

      theme: ThemeData(
        useMaterial3: true,

        colorScheme:
            ColorScheme.fromSeed(
          seedColor:
              const Color(
                  0xFF4D55CC),
          primary:
              const Color(
                  0xFF211C84),
          secondary:
              const Color(
                  0xFF7A73D1),
          surface:
              Colors.white,
        ),

        scaffoldBackgroundColor:
            const Color(
                0xFFF8F7FC),

        appBarTheme:
            const AppBarTheme(
          backgroundColor:
              Color(
                  0xFF211C84),
          foregroundColor:
              Colors.white,
          centerTitle: true,
          elevation: 0,
        ),

        floatingActionButtonTheme:
            const FloatingActionButtonThemeData(
          backgroundColor:
              Color(
                  0xFF4D55CC),
          foregroundColor:
              Colors.white,
        ),

        elevatedButtonTheme:
            ElevatedButtonThemeData(
          style:
              ElevatedButton.styleFrom(
            backgroundColor:
                const Color(
                    0xFF4D55CC),
            foregroundColor:
                Colors.white,
            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                      14),
            ),
            padding:
                const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),
          ),
        ),

        inputDecorationTheme:
            InputDecorationTheme(
          filled: true,
          fillColor:
              Colors.white,
          border:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(
                    14),
            borderSide:
                BorderSide.none,
          ),
          enabledBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(
                    14),
            borderSide:
                BorderSide.none,
          ),
          focusedBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(
                    14),
            borderSide:
                const BorderSide(
              color: Color(
                  0xFF4D55CC),
              width: 2,
            ),
          ),
        ),

        cardTheme:
            CardThemeData(
          color: Colors.white,
          elevation: 3,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
                    16),
          ),
        ),
      ),

      initialRoute: 'login',

      routes: {
        'login': (context) =>
            const LoginScreen(),

        'register': (context) =>
            const RegisterScreen(),

        'home': (context) =>
            const HomeScreen(),

        'notes': (context) =>
            const NotesScreen(),

        'chat': (context) =>
            const ChatScreen(),

        'gallery': (context) =>
            const GalleryScreen(),
        'camera': (context) =>
            const CameraScreen(),
      },
    );
  }
}