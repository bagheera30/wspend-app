import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraHelper {
  static Future<List<CameraDescription>> loadCameras() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      return await availableCameras();
    } catch (e) {
      print('Error loading cameras: $e');
      return [];
    }
  }

  static Future<File?> takePicture(CameraDescription camera) async {
    final controller = CameraController(camera, ResolutionPreset.medium);
    await controller.initialize();

    final image = await controller.takePicture();
    final pictureFile = File(image.path);

    await controller.dispose();

    return pictureFile;
  }
}
