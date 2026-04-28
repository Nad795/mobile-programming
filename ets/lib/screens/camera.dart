import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ets/database/media_database.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() =>
      _CameraScreenState();
}

class _CameraScreenState
    extends State<CameraScreen> {
  final ImagePicker picker =
      ImagePicker();

  Future<void> takePhoto() async {
    final XFile? photo =
        await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (photo == null) return;

    await MediaDatabase.instance
        .insertImage(photo.path);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
            "Saved to Gallery"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Camera")),

      body: Center(
        child: ElevatedButton.icon(
          onPressed: takePhoto,
          icon: const Icon(Icons.camera),
          label:
              const Text("Take Photo"),
        ),
      ),
    );
  }
}