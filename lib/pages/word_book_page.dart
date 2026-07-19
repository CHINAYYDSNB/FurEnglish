import 'package:flutter/material.dart';
import '../theme/colors.dart';

class WordBookPage extends StatelessWidget {
  const WordBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('生词本')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.book_outlined, size: 64, color: FurColors.primary.withAlpha(100)),
            const SizedBox(height: 12),
            Text('还没有收藏单词哦~', style: theme.textTheme.bodyLarge?.copyWith(color: FurColors.onSurfaceVariant)),
            const SizedBox(height: 4),
            Text('搜一个词试试吧', style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
