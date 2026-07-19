import 'package:flutter/material.dart';
import '../models/dictionary_entry.dart';
import '../api/dictionary_api.dart';
import '../api/translate_api.dart';
import '../theme/colors.dart';

/// Show word/phrase definition in bottom sheet
void showWordPopup(BuildContext context, String word) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _WordSheet(word: word),
  );
}

class _WordSheet extends StatefulWidget {
  final String word;
  const _WordSheet({required this.word});

  @override
  State<_WordSheet> createState() => _WordSheetState();
}

class _WordSheetState extends State<_WordSheet> {
  DictionaryEntry? _entry;
  String? _zhMeaning;
  bool _loading = true;
  bool _isSingleWord = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _isSingleWord = !widget.word.contains(' ');

    if (_isSingleWord) {
      // Single word: use dictionary API
      try {
        final results = await DictionaryApi.search(widget.word);
        if (mounted) setState(() { _entry = results.isNotEmpty ? results.first : null; _loading = false; });
      } catch (_) {
        if (mounted) setState(() => _loading = false);
      }
    } else {
      // Phrase: translate en→zh for meaning
      try {
        _zhMeaning = await TranslateApi.enToZh(widget.word);
        if (mounted) setState(() => _loading = false);
      } catch (_) {
        if (mounted) setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: _isSingleWord ? 0.45 : 0.3,
      minChildSize: 0.25,
      maxChildSize: 0.8,
      expand: false,
      builder: (context, scrollController) {
        if (_loading) {
          return const Center(child: CircularProgressIndicator(color: FurColors.primary));
        }

        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: FurColors.outline.withAlpha(80), borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            // Title
            Text(widget.word, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 16),
            if (_isSingleWord)
              ..._buildWordDef(theme)
            else
              ..._buildPhraseDef(theme),
          ],
        );
      },
    );
  }

  List<Widget> _buildPhraseDef(ThemeData theme) {
    if (_zhMeaning == null || _zhMeaning!.isEmpty) {
      return [Text('暂无释义', style: theme.textTheme.bodyMedium)];
    }
    final words = widget.word
        .split(RegExp(r'[ ,./;:!?]+'))
        .map((w) => w.replaceAll(RegExp(r'[^a-zA-Z-]'), ''))
        .where((w) => w.length > 1)
        .toList();

    return [
      // Chinese meaning
      Row(
        children: [
          const Icon(Icons.translate, size: 16, color: FurColors.primary),
          const SizedBox(width: 6),
          Text('中文释义', style: theme.textTheme.labelSmall),
        ],
      ),
      const SizedBox(height: 8),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: FurColors.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(_zhMeaning!, style: theme.textTheme.bodyLarge?.copyWith(
          color: FurColors.onSurface,
          fontWeight: FontWeight.w600,
        )),
      ),
      const SizedBox(height: 16),
      // Tappable word chips
      Text('点击单词查看详细释义', style: theme.textTheme.labelSmall),
      const SizedBox(height: 8),
      Wrap(
        spacing: 6,
        runSpacing: 6,
        children: words.map((w) => ActionChip(
          label: Text(w, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          backgroundColor: FurColors.surface,
          side: const BorderSide(color: FurColors.divider),
          onPressed: () {
            // Close current popup, open word popup
            Navigator.pop(context);
            showWordPopup(context, w.toLowerCase());
          },
        )).toList(),
      ),
    ];
  }

  List<Widget> _buildWordDef(ThemeData theme) {
    if (_entry == null) {
      return [Text('暂无 "${widget.word}" 的释义', style: theme.textTheme.bodyMedium)];
    }

    final entry = _entry!;
    return [
      if (entry.bestPhonetic.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(entry.bestPhonetic, style: theme.textTheme.labelSmall),
        ),
      ...entry.meanings.map((m) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(color: FurColors.primaryContainer, borderRadius: BorderRadius.circular(8)),
              child: Text(m.partOfSpeech, style: const TextStyle(
                fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.w700, color: FurColors.primary,
              )),
            ),
            const SizedBox(height: 6),
            ...m.definitions.take(3).map((d) => Padding(
              padding: const EdgeInsets.only(bottom: 6, left: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(d.definition, style: theme.textTheme.bodyLarge),
                  if (d.example != null && d.example!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text('"${d.example}"', style: theme.textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic, color: FurColors.onSurfaceVariant,
                      )),
                    ),
                ],
              ),
            )),
          ],
        ),
      )),
    ];
  }
}
