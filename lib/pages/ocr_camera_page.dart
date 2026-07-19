import 'package:flutter/material.dart';
class OcrCameraPage extends StatelessWidget {
  const OcrCameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('拍照取词')),
      body: Center(
        child: Text('OCR — 开发中', style: Theme.of(context).textTheme.titleLarge),
      ),
    );
  }
}
