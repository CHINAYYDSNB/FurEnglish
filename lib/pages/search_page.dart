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
                hintText: '输入英语单词 (如 hello)...',
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
              child: Wrap(
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
    // Loading
    if (state.loading) {
      return const Center(child: CircularProgressIndicator(color: FurColors.primary));
    }
    // Error
    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off_rounded, size: 64, color: FurColors.primary.withAlpha(100)),
              const SizedBox(height: 12),
              Text(state.error!, style: theme.textTheme.bodyLarge?.copyWith(color: FurColors.onSurfaceVariant)),
              const SizedBox(height: 12),
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
    // Results
    if (state.results.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
        itemCount: state.results.length,
        itemBuilder: (context, i) => WordCard(
          entry: state.results[i],
          onTap: () => context.push('/word/${state.results[i].word}'),
        ),
      );
    }
    // Empty (initial)
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.menu_book_rounded, size: 64, color: FurColors.primary.withAlpha(100)),
          const SizedBox(height: 12),
          Text('搜索你想要的单词~', style: theme.textTheme.bodyLarge?.copyWith(color: FurColors.onSurfaceVariant)),
        ],
      ),
    );
  }
}
