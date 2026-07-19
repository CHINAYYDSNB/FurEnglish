import 'package:flutter/material.dart';
import '../theme/colors.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('复习')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.school_outlined, size: 64, color: FurColors.primary.withAlpha(100)),
            const SizedBox(height: 12),
            Text('今天没有要复习的单词~', style: theme.textTheme.bodyLarge?.copyWith(color: FurColors.onSurfaceVariant)),
            const SizedBox(height: 4),
            Text('收藏单词后会自动排入复习计划', style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
