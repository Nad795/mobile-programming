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

  void openPreview(String path) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            PreviewScreen(path: path),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F3FF),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF211C84),
        title: const Text(
          "Gallery",
          style:
              TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: images.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_library,
                    size: 70,
                    color:
                        Color(0xFF7A73D1),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "No Images Yet",
                    style: TextStyle(
                      fontSize: 18,
                      color:
                          Color(0xFF211C84),
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding:
                  const EdgeInsets.all(
                      12),
              itemCount:
                  images.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder:
                  (context, index) {
                final img =
                    images[index];

                return GestureDetector(
                  onTap: () =>
                      openPreview(
                          img["path"]),
                  child: Hero(
                    tag: img["path"],
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius
                              .circular(
                                  18),
                      child: Image.file(
                        File(
                            img["path"]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class PreviewScreen
    extends StatelessWidget {
  final String path;

  const PreviewScreen({
    super.key,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.black,

      appBar: AppBar(
        backgroundColor:
            Colors.transparent,
        elevation: 0,
      ),

      body: Center(
        child: Hero(
          tag: path,
          child: InteractiveViewer(
            child: Image.file(
              File(path),
            ),
          ),
        ),
      ),
    );
  }
}