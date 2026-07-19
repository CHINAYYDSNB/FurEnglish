import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/search_provider.dart';
import '../utils/phrase_splitter.dart';
import '../widgets/word_card.dart';
import '../widgets/word_popup.dart';
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
          if (state.history.isNotEmpty && state.query.isEmpty && !state.loading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('最近搜索', style: theme.textTheme.labelSmall),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6, runSpacing: 4,
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

    // ── Chinese: show translation sentence card with tappable words ──
    if (state.isChineseQuery) {
      return _TranslationSentenceView(
        query: state.query,
        translation: state.translatedPhrase ?? '',
        phrases: state.aiPhrases,
      );
    }

    // ── English phrase: word breakdown ──
    if (state.isPhrase && state.phraseWords.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
        itemCount: state.phraseWords.length,
        itemBuilder: (context, i) {
          final pw = state.phraseWords[i];
          if (pw.entry != null) {
            return WordCard(entry: pw.entry!, onTap: () => context.push('/word/${pw.word}'));
          }
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(child: Text(pw.word, style: theme.textTheme.titleLarge)),
                  const Text('未找到', style: TextStyle(color: FurColors.onSurfaceVariant)),
                ],
              ),
            ),
          );
        },
      );
    }

    // ── English single word results ──
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

    // ── Empty initial state ──
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

/// Translation sentence card — each word is tappable for dictionary lookup
class _TranslationSentenceView extends StatelessWidget {
  final String query;
  final String translation;
  final List<String> phrases;

  const _TranslationSentenceView({
    required this.query,
    required this.translation,
    required this.phrases,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayPhrases = phrases.isNotEmpty ? phrases : splitIntoPhrases(translation);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Translation card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.translate, color: FurColors.primary, size: 20),
                      const SizedBox(width: 8),
                      Text('翻译结果', style: theme.textTheme.labelSmall),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    query,
                    style: theme.textTheme.bodyLarge?.copyWith(color: FurColors.onSurfaceVariant),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    translation,
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 24,
                      color: FurColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Tappable phrase chips
          Text('点击短语查看关键词释义', style: theme.textTheme.labelSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: displayPhrases.map((phrase) {
              final lookup = phrase.contains(' ') ? phrase : phraseKeyWord(phrase);
              return Material(
                color: FurColors.surface,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    showWordPopup(context, lookup);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: FurColors.divider),
                    ),
                    child: Text(
                      phrase,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: FurColors.onSurface,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
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
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: FurColors.primary.withAlpha(100)),
            const SizedBox(height: 12),
            Text(error, textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(color: FurColors.onSurfaceVariant)),
            const SizedBox(height: 16),
            FilledButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh, size: 18), label: const Text('重试')),
          ],
        ),
      ),
    );
  }
}
