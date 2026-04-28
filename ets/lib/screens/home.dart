import 'package:flutter/material.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {
  String time = "12:00";
  String dateText = "Tuesday, April 28";
  Timer? timer;

  @override
  void initState() {
    super.initState();
    updateTime();

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => updateTime(),
    );
  }

  void updateTime() {
    final now = DateTime.now();

    final formattedTime =
        "${now.hour.toString().padLeft(2, '0')}:"
        "${now.minute.toString().padLeft(2, '0')}";

    final days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];

    final dayName = days[now.weekday - 1];

    final months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    final monthName = months[now.month - 1];

    final formattedDate =
        "$dayName, $monthName ${now.day}";

    setState(() {
      time = formattedTime;
      dateText = formattedDate;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF211C84),
              Color(0xFF4D55CC),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 25),

              Text(
                time,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                dateText,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 35),

              Expanded(
                child: GridView.count(
                  padding:
                      const EdgeInsets.all(24),
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,

                  children: [
                    appIcon(
                      context,
                      Icons.chat,
                      "Chat",
                      const Color(
                          0xFF7A73D1),
                      'chat',
                    ),

                    appIcon(
                      context,
                      Icons.notes,
                      "Notes",
                      const Color(
                          0xFFB5A8D5),
                      'notes',
                    ),

                    appIcon(
                      context,
                      Icons.photo_library,
                      "Gallery",
                      const Color(
                          0xFF7A73D1),
                      'gallery',
                    ),

                    appIcon(
                      context,
                      Icons.map,
                      "Map",
                      const Color(
                          0xFFB5A8D5),
                      'home',
                    ),

                    appIcon(
                      context,
                      Icons.camera_alt,
                      "Camera",
                      const Color(
                          0xFF7A73D1),
                      'home',
                    ),

                    appIcon(
                      context,
                      Icons.logout,
                      "Logout",
                      Colors.redAccent,
                      'login',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget appIcon(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    String route,
  ) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(
        context,
        route,
      ),
      child: Column(
        children: [
          Container(
            height: 68,
            width: 68,

            decoration:
                BoxDecoration(
              color:
                  color.withOpacity(
                      0.95),
              borderRadius:
                  BorderRadius.circular(
                      20),
            ),

            child: Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            label,
            style:
                const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight:
                  FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}