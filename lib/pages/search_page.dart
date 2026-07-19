import 'package:flutter/material.dart';
import '../theme/colors.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FurEnglish'),
        actions: [
          IconButton(
            icon: const Icon(Icons.document_scanner_outlined, color: FurColors.primary),
            tooltip: '拍照取词',
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: '输入英语单词 (如 hello)...',
                prefixIcon: const Icon(Icons.search, color: FurColors.onSurfaceVariant),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward, color: FurColors.primary),
                  onPressed: () {},
                ),
              ),
              onSubmitted: (_) {},
            ),
            const SizedBox(height: 24),
            // Empty state placeholder
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.menu_book_rounded, size: 64, color: FurColors.primary.withAlpha(100)),
                    const SizedBox(height: 12),
                    Text(
                      '搜索你想要的单词~',
                      style: theme.textTheme.bodyLarge?.copyWith(color: FurColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
