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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: (v) => ref.read(searchProvider.notifier).updateQuery(v),
              onSubmitted: (_) => _doSearch(),
              decoration: InputDecoration(
                hintText: '查单词 / 搜句子 / 中文翻译...',
                prefixIcon: const Icon(Icons.search, color: FurColors.onSurfaceVariant),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward, color: FurColors.primary),
                  onPressed: state.query.isEmpty ? null : _doSearch,
                ),
              ),
            ),
          ),
          if (state.history.isNotEmpty && state.query.isEmpty && state.results.isEmpty && !state.loading)
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
          Expanded(child: _buildBody(state, theme)),
        ],
      ),
    );
  }

  Widget _buildBody(SearchState state, ThemeData theme) {
    if (state.loading) {
      return const Center(child: CircularProgressIndicator(color: FurColors.primary));
    }

    if (state.error != null) {
      return _ErrorView(error: state.error!, onRetry: _doSearch);
    }

    // Phrase results (multi-word / sentence)
    if (state.phraseWords.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
        itemCount: state.phraseWords.length + (state.translatedPhrase != null ? 1 : 0),
        itemBuilder: (context, i) {
          if (state.translatedPhrase != null && i == 0) {
            return _TranslationHeader(query: state.query, translation: state.translatedPhrase!);
          }
          final pwIdx = state.translatedPhrase != null ? i - 1 : i;
          final pw = state.phraseWords[pwIdx];
          if (pw.entry != null) {
            return WordCard(
              entry: pw.entry!,
              onTap: () => context.push('/word/${pw.word}'),
            );
          }
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(child: Text(pw.word, style: theme.textTheme.titleLarge)),
                  const Icon(Icons.search_off, color: FurColors.outline, size: 20),
                ],
              ),
            ),
          );
        },
      );
    }

    // Single word results
    if (state.results.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
        itemCount: state.results.length + (state.translatedPhrase != null ? 1 : 0),
        itemBuilder: (context, i) {
          if (state.translatedPhrase != null && i == 0) {
            return _TranslationHeader(query: state.query, translation: state.translatedPhrase!);
          }
          final idx = state.translatedPhrase != null ? i - 1 : i;
          return WordCard(
            entry: state.results[idx],
            onTap: () => context.push('/word/${state.results[idx].word}'),
          );
        },
      );
    }

    // Empty state
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
            Text('支持单词、短语、句子和中英文搜索', style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _TranslationHeader extends StatelessWidget {
  final String query;
  final String translation;
  const _TranslationHeader({required this.query, required this.translation});

  bool get _isSentence => translation.contains(' ') && translation.split(' ').length > 2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        color: FurColors.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Full translation
              Row(
                children: [
                  const Icon(Icons.translate, color: FurColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyLarge,
                        children: [
                          TextSpan(text: query, style: const TextStyle(fontWeight: FontWeight.w600)),
                          const TextSpan(text: '\n', style: TextStyle(fontSize: 4)),
                          TextSpan(
                            text: translation,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: FurColors.primary,
                              fontSize: _isSentence ? 18 : 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (_isSentence) ...[
                const SizedBox(height: 10),
                const Divider(color: FurColors.primary, height: 1),
                const SizedBox(height: 8),
                Text('拆分释义', style: Theme.of(context).textTheme.labelSmall),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: FurColors.primary.withAlpha(100)),
            const SizedBox(height: 12),
            Text(error, textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: FurColors.onSurfaceVariant)),
            const SizedBox(height: 16),
            FilledButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh, size: 18), label: const Text('重试')),
          ],
        ),
      ),
    );
  }
}
