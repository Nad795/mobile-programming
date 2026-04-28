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

  bool busy = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      openCamera();
    });
  }

  Future<void> openCamera() async {
    if (busy) return;

    busy = true;

    final XFile? photo =
        await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (!context.mounted) return;

    if (photo == null) {
      Navigator.pop(context);
      return;
    }

    await MediaDatabase.instance
        .insertImage(
      photo.path,
      source: "camera",
    );

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content:
            Text("Saved to Gallery"),
        duration:
            Duration(seconds: 1),
      ),
    );

    busy = false;

    await Future.delayed(
      const Duration(
        milliseconds: 500,
      ),
    );

    if (context.mounted) {
      openCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          "Opening Camera...",
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}