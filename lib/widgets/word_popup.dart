import 'package:flutter/material.dart';
import '../models/dictionary_entry.dart';
import '../api/dictionary_api.dart';
import '../theme/colors.dart';

/// Duolingo-style word popup — tap a word, see definition in bottom sheet
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
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final results = await DictionaryApi.search(widget.word);
      if (mounted) setState(() { _entry = results.isNotEmpty ? results.first : null; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      expand: false,
      builder: (context, scrollController) {
        if (_loading) {
          return const Center(child: CircularProgressIndicator(color: FurColors.primary));
        }

        if (_entry == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.search_off, size: 40, color: FurColors.outline),
                const SizedBox(height: 8),
                Text('暂无 "${widget.word}" 的释义', style: theme.textTheme.bodyMedium),
              ],
            ),
          );
        }

        final entry = _entry!;
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: FurColors.outline.withAlpha(80),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Word title
            Row(
              children: [
                Expanded(child: Text(entry.word, style: theme.textTheme.headlineMedium)),
                if (entry.bestPhonetic.isNotEmpty)
                  Text(entry.bestPhonetic, style: theme.textTheme.labelSmall),
              ],
            ),
            const SizedBox(height: 16),
            // Meanings
            ...entry.meanings.map((m) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: FurColors.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(m.partOfSpeech, style: const TextStyle(
                      fontFamily: 'Nunito', fontSize: 12,
                      fontWeight: FontWeight.w700, color: FurColors.primary,
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
          ],
        );
      },
    );
  }
}
