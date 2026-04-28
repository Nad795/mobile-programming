import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ets/database/chat_database.dart';
import 'package:ets/services/notification.dart';

class ChatRoomScreen extends StatefulWidget {
  final String roomName;

  const ChatRoomScreen({
    super.key,
    required this.roomName,
  });

  @override
  State<ChatRoomScreen> createState() =>
      _ChatRoomScreenState();
}

class _ChatRoomScreenState
    extends State<ChatRoomScreen> {
  final TextEditingController messageController =
      TextEditingController();

  final ImagePicker picker = ImagePicker();

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  Future<void> loadMessages() async {
    final all =
        await ChatDatabase.instance.getMessages();

    setState(() {
      messages = all
          .where((msg) =>
              msg["room"] == widget.roomName)
          .toList();
    });
  }

  List<String> getReplies() {
    switch (widget.roomName) {
      case "Dia":
        return [
          "Hmm.",
          "Kamu gimana?",
          "Jaga diri ya.",
          "Aku paham.",
        ];

      case "Teman Hangout":
        return [
          "WKWKWK 😆",
          "Gaskeun 🔥",
          "Ngopi yok",
          "Lu lucu juga",
        ];

      case "Teman Curhat":
        return [
          "Pelan-pelan ya.",
          "Aku ngerti kok.",
          "Semua akan lewat.",
          "Kamu hebat loh.",
        ];

      case "Teman yang Mirip Dia":
        return [
          "...",
          "Kita pernah ketemu?",
          "Aneh ya.",
          "Kamu terlihat gelisah.",
        ];

      case "Temannya Dia":
        return [
          "Dia tadi lewat.",
          "Katanya sibuk.",
          "Kemarin ketemu dia.",
          "Oh gitu ya.",
        ];

      default:
        return [
          "Deadline jangan lupa ya.",
          "Meeting jam 7.",
          "Nanti aku revisi.",
          "Makasih bantuannya.",
        ];
    }
  }

  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    await ChatDatabase.instance.insertMessage(
      widget.roomName,
      messageController.text,
      true,
    );

    messageController.clear();

    await loadMessages();

    Future.delayed(
      const Duration(seconds: 2),
      () async {
        final replies = getReplies();

        final reply = replies[
            Random().nextInt(replies.length)];

        await ChatDatabase.instance
            .insertMessage(
          widget.roomName,
          reply,
          false,
        );

        await NotificationService
            .showNotification(
          widget.roomName,
          reply,
        );

        await loadMessages();
      },
    );
  }

  Future<void> openCamera() async {
    final XFile? photo =
        await picker.pickImage(
      source: ImageSource.camera,
    );

    if (photo != null) {
      await ChatDatabase.instance
          .insertMessage(
        widget.roomName,
        photo.path,
        true,
      );

      await loadMessages();
    }
  }

  Future<void> deleteMessage(int id) async {
    await ChatDatabase.instance
        .deleteMessage(id);

    await loadMessages();
  }

  Widget bubble(
      Map<String, dynamic> msg) {
    final bool isMe = msg["isMe"] == 1;

    return GestureDetector(
      onLongPress: () =>
          deleteMessage(msg["id"]),
      child: Align(
        alignment: isMe
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          margin:
              const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          padding:
              const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isMe
                ? Colors.blue
                : Colors.grey[300],
            borderRadius:
                BorderRadius.circular(
                    16),
          ),
          child: msg["text"]
                  .toString()
                  .endsWith(".jpg") ||
              msg["text"]
                  .toString()
                  .endsWith(".png")||
              msg["text"]
                  .toString()
                  .endsWith(".jpeg")
              ? Image.file(
                  File(msg["text"]),
                  width: 180,
                )
              : Text(
                  msg["text"],
                  style: TextStyle(
                    color: isMe
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.roomName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount:
                  messages.length,
              itemBuilder:
                  (context, index) {
                return bubble(
                    messages[index]);
              },
            ),
          ),
          Container(
            padding:
                const EdgeInsets.all(
                    8),
            color: Colors.grey[200],
            child: Row(
              children: [
                IconButton(
                  onPressed:
                      openCamera,
                  icon: const Icon(
                    Icons.camera_alt,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller:
                        messageController,
                    decoration:
                        const InputDecoration(
                      hintText:
                          "Type message...",
                      border:
                          OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed:
                      sendMessage,
                  icon: const Icon(
                    Icons.send,
                  ),
                  color:
                      Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}