import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dictionary_entry.dart';
import '../api/dictionary_api.dart';
import '../widgets/meaning_section.dart';
import '../widgets/phonetic_badge.dart';
import '../theme/colors.dart';

class WordDetailPage extends ConsumerStatefulWidget {
  final String word;
  const WordDetailPage({super.key, required this.word});

  @override
  ConsumerState<WordDetailPage> createState() => _WordDetailPageState();
}

class _WordDetailPageState extends ConsumerState<WordDetailPage> {
  List<DictionaryEntry>? _entries;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() { _loading = true; _error = null; });
    try {
      final e = await DictionaryApi.search(widget.word);
      if (mounted) setState(() { _entries = e; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.word),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            tooltip: '收藏',
            onPressed: () {},
          ),
        ],
      ),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: FurColors.primary));
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off_rounded, size: 64, color: FurColors.primary.withAlpha(100)),
              const SizedBox(height: 12),
              Text(_error!, textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(color: FurColors.onSurfaceVariant)),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _fetch,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('重试'),
              ),
            ],
          ),
        ),
      );
    }
    if (_entries == null || _entries!.isEmpty) return const SizedBox.shrink();

    final entry = _entries!.first;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      children: [
        // Word + phonetic
        Row(
          children: [
            Expanded(
              child: Text(entry.word, style: theme.textTheme.displayLarge),
            ),
            PhoneticBadge(
              phoneticText: entry.bestPhonetic,
              audioUrl: entry.bestAudioUrl,
              onPlay: () {/* TODO: TTS Phase 3 */},
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Meanings
        ...entry.meanings.map((m) => MeaningSection(meaning: m)),
        // Origin
        if (entry.origin != null && entry.origin!.isNotEmpty) ...[
          const Divider(color: FurColors.divider),
          const SizedBox(height: 8),
          Text('词源', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(entry.origin!, style: theme.textTheme.bodyMedium),
        ],
        const SizedBox(height: 40),
      ],
    );
  }
}
