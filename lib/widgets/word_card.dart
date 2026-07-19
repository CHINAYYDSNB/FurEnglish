import 'package:flutter/material.dart';
import '../models/dictionary_entry.dart';
import '../theme/colors.dart';

class WordCard extends StatelessWidget {
  final DictionaryEntry entry;
  final VoidCallback onTap;

  const WordCard({super.key, required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final firstDef = entry.meanings.firstOrNull?.definitions.firstOrNull;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(entry.word,
                            style: theme.textTheme.titleLarge),
                        if (entry.bestPhonetic.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Text(entry.bestPhonetic,
                              style: theme.textTheme.labelSmall),
                        ],
                      ],
                    ),
                    if (firstDef != null) ...[
                      const SizedBox(height: 4),
                      Text(firstDef.definition,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium),
                    ],
                    if (entry.meanings.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: entry.meanings.map((m) => Chip(
                          label: Text(m.partOfSpeech),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        )).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: FurColors.outline),
            ],
          ),
        ),
      ),
    );
  }
}
