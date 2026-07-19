import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dictionary_entry.dart';
import '../api/dictionary_api.dart';
import '../api/word_info_api.dart';
import '../widgets/meaning_section.dart';
import '../widgets/phonetic_badge.dart';
import '../widgets/audio_play_button.dart';
import '../theme/colors.dart';

class WordDetailPage extends ConsumerStatefulWidget {
  final String word;
  const WordDetailPage({super.key, required this.word});

  @override
  ConsumerState<WordDetailPage> createState() => _WordDetailPageState();
}

class _WordDetailPageState extends ConsumerState<WordDetailPage> {
  List<DictionaryEntry>? _entries;
  List<String> _relatedRoots = [];
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
      final results = await Future.wait([
        DictionaryApi.search(widget.word),
        WordInfoApi.getRelated(widget.word),
      ]);
      if (mounted) {
        setState(() {
          _entries = results[0] as List<DictionaryEntry>;
          _relatedRoots = WordInfoApi.extractRoots(results[1] as List<Map<String, dynamic>>);
          _loading = false;
        });
      }
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
    if (_loading) return const Center(child: CircularProgressIndicator(color: FurColors.primary));
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
        // Word + phonetic + play
        Row(
          children: [
            Expanded(child: Text(entry.word, style: theme.textTheme.displayLarge)),
            const SizedBox(width: 8),
            AudioPlayButton(text: entry.word),
            if (entry.bestPhonetic.isNotEmpty) ...[
              const SizedBox(width: 8),
              PhoneticBadge(phoneticText: entry.bestPhonetic, audioUrl: entry.bestAudioUrl, onPlay: () {}),
            ],
          ],
        ),
        const SizedBox(height: 20),
        // ── Meanings ──
        ...entry.meanings.map((m) => MeaningSection(meaning: m)),
        // ── Etymology / Origin ──
        if (entry.origin != null && entry.origin!.isNotEmpty) ...[
          _SectionHeader(icon: Icons.history, title: '词源'),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: FurColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: FurColors.divider),
            ),
            child: Text(entry.origin!, style: theme.textTheme.bodyMedium),
          ),
          const SizedBox(height: 16),
        ],
        // ── Related roots / affixes ──
        if (_relatedRoots.isNotEmpty) ...[
          _SectionHeader(icon: Icons.account_tree, title: '词根 / 关联词'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _relatedRoots.map((r) => ActionChip(
              label: Text(r),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => WordDetailPage(word: r),
                ));
              },
            )).toList(),
          ),
        ],
        const SizedBox(height: 20),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: FurColors.primary),
        const SizedBox(width: 6),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}
