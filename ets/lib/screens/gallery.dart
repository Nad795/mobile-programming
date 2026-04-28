import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ets/database/media_database.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() =>
      _GalleryScreenState();
}

class _GalleryScreenState
    extends State<GalleryScreen> {
  List<Map<String, dynamic>> images =
      [];

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  Future<void> loadImages() async {
    final data =
        await MediaDatabase.instance
            .getImages();

    setState(() {
      images = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Gallery")),

      body: images.isEmpty
          ? const Center(
              child: Text("No Images"),
            )
          : GridView.builder(
              padding:
                  const EdgeInsets.all(10),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: images.length,
              itemBuilder:
                  (context, index) {
                final img =
                    images[index];

                return ClipRRect(
                  borderRadius:
                      BorderRadius.circular(
                          12),
                  child: Image.file(
                    File(img["path"]),
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
    );
  }
}