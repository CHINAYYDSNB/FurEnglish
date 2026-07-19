import 'package:flutter/material.dart';
import '../models/dictionary_entry.dart';
import '../theme/colors.dart';

class MeaningSection extends StatelessWidget {
  final Meaning meaning;
  const MeaningSection({super.key, required this.meaning});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Part of speech badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: FurColors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  meaning.partOfSpeech,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: FurColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Definitions
          ...meaning.definitions.map((d) => _DefinitionTile(defn: d, theme: theme)),
          // Synonyms
          if (meaning.synonyms.isNotEmpty) ...[
            const SizedBox(height: 8),
            _TagRow(label: '同义词', tags: meaning.synonyms, color: FurColors.success),
          ],
          // Antonyms
          if (meaning.antonyms.isNotEmpty) ...[
            const SizedBox(height: 4),
            _TagRow(label: '反义词', tags: meaning.antonyms, color: FurColors.error),
          ],
        ],
      ),
    );
  }
}

class _DefinitionTile extends StatelessWidget {
  final Definition defn;
  final ThemeData theme;
  const _DefinitionTile({required this.defn, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(defn.definition, style: theme.textTheme.bodyLarge),
          if (defn.example != null && defn.example!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: FurColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: FurColors.divider),
              ),
              child: Text(
                '"${defn.example}"',
                style: theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TagRow extends StatelessWidget {
  final String label;
  final List<String> tags;
  final Color color;
  const _TagRow({required this.label, required this.tags, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label：', style: Theme.of(context).textTheme.labelSmall),
        Expanded(
          child: Text(
            tags.take(8).join('、'),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
