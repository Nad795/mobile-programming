import 'package:flutter/material.dart';
import 'chat_room.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  final List<Map<String, dynamic>> chatRooms = const [
    {
      "name": "Dia",
      "icon": Icons.favorite,
      "color": Colors.red,
    },
    {
      "name": "Teman Hangout",
      "icon": Icons.emoji_emotions,
      "color": Colors.orange,
    },
    {
      "name": "Teman Curhat",
      "icon": Icons.self_improvement,
      "color": Colors.blue,
    },
    {
      "name": "Teman yang Mirip Dia",
      "icon": Icons.visibility,
      "color": Colors.purple,
    },
    {
      "name": "Temannya Dia",
      "icon": Icons.people,
      "color": Colors.green,
    },
    {
      "name": "Teman Satu Proyek",
      "icon": Icons.work,
      "color": Colors.teal,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: chatRooms.length,
        itemBuilder: (context, index) {
          final room = chatRooms[index];

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: room["color"],
              child: Icon(
                room["icon"],
                color: Colors.white,
              ),
            ),
            title: Text(
              room["name"],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text("Tap to open chat"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatRoomScreen(
                    roomName: room["name"],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}