import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraDialog extends StatelessWidget {
  final List<CameraDescription> cameras;

  const CameraDialog({required this.cameras});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Pilih Kamera'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: cameras.map((camera) {
          return ListTile(
            title: Text(camera.lensDirection == CameraLensDirection.front
                ? 'Kamera Depan'
                : 'Kamera Belakang'),
            onTap: () {
              Navigator.pop(context, camera);
            },
          );
        }).toList(),
      ),
    );
  }
}
