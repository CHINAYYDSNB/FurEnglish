import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/search_provider.dart';
import '../widgets/word_card.dart';
import '../theme/colors.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _doSearch() {
    _focusNode.unfocus();
    ref.read(searchProvider.notifier).search();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FurEnglish'),
        actions: [
          IconButton(
            icon: const Icon(Icons.document_scanner_outlined, color: FurColors.primary),
            tooltip: '拍照取词',
            onPressed: () => context.push('/ocr'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: (v) => ref.read(searchProvider.notifier).updateQuery(v),
              onSubmitted: (_) => _doSearch(),
              decoration: InputDecoration(
                hintText: '查英文单词 / 搜中文翻译...',
                prefixIcon: const Icon(Icons.search, color: FurColors.onSurfaceVariant),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward, color: FurColors.primary),
                  onPressed: state.query.isEmpty ? null : _doSearch,
                ),
              ),
            ),
          ),
          // History chips
          if (state.history.isNotEmpty && state.results.isEmpty && !state.loading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('最近搜索', style: theme.textTheme.labelSmall),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: state.history.map((h) => ActionChip(
                      label: Text(h),
                      onPressed: () {
                        _controller.text = h;
                        ref.read(searchProvider.notifier).search(h);
                      },
                    )).toList(),
                  ),
                ],
              ),
            ),
          // Results / Loading / Empty / Error
          Expanded(
            child: _buildBody(state, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(SearchState state, ThemeData theme) {
    if (state.loading) {
      return const Center(child: CircularProgressIndicator(color: FurColors.primary));
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off_rounded, size: 64, color: FurColors.primary.withAlpha(100)),
              const SizedBox(height: 12),
              Text(state.error!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(color: FurColors.onSurfaceVariant)),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _doSearch,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('重试'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.results.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
        itemCount: state.results.length + (state.translatedWord != null ? 1 : 0),
        itemBuilder: (context, i) {
          // Translation header for Chinese queries
          if (state.translatedWord != null && i == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                color: FurColors.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      const Icon(Icons.translate, color: FurColors.primary, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: theme.textTheme.bodyLarge,
                            children: [
                              TextSpan(
                                text: state.query,
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                              const TextSpan(text: ' → '),
                              TextSpan(
                                text: state.translatedWord!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: FurColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          final entryIdx = state.translatedWord != null ? i - 1 : i;
          return WordCard(
            entry: state.results[entryIdx],
            onTap: () => context.push('/word/${state.results[entryIdx].word}'),
          );
        },
      );
    }

    // Empty (initial state — no search yet)
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_rounded, size: 72, color: FurColors.primary.withAlpha(80)),
            const SizedBox(height: 16),
            Text('搜你想查的词~', style: theme.textTheme.titleLarge?.copyWith(color: FurColors.onSurfaceVariant)),
            const SizedBox(height: 8),
            Text('支持中英文混合搜索', style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
