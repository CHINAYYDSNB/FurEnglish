import 'package:flutter/material.dart';
class WordDetailPage extends StatelessWidget {
  final String word;
  const WordDetailPage({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(word),
      ),
      body: Center(
        child: Text('$word — 开发中', style: Theme.of(context).textTheme.titleLarge),
      ),
    );
  }
}
