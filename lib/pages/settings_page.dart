import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/tts_provider.dart';
import '../theme/colors.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ttsState = ref.watch(ttsProvider);
    final ratePercent = (ttsState.rate * 100).round();

    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // TTS Speed
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.speed, color: FurColors.primary, size: 22),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text('发音速度', style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                      Text('$ratePercent%',
                          style: const TextStyle(fontFamily: 'Nunito', fontSize: 14, color: FurColors.onSurfaceVariant)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: ttsState.rate,
                    min: 0.1,
                    max: 1.0,
                    divisions: 9,
                    activeColor: FurColors.primary,
                    inactiveColor: FurColors.divider,
                    onChanged: (v) => ref.read(ttsProvider.notifier).setRate(v),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('慢', style: TextStyle(fontFamily: 'Nunito', fontSize: 12, color: FurColors.onSurfaceVariant)),
                      Text('快', style: TextStyle(fontFamily: 'Nunito', fontSize: 12, color: FurColors.onSurfaceVariant)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // About
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline, color: FurColors.primary),
              title: const Text('关于 FurEnglish'),
              subtitle: const Text('v0.1.0'),
              trailing: const Icon(Icons.chevron_right, color: FurColors.outline),
              onTap: () => showAboutDialog(
                context: context,
                applicationName: 'FurEnglish',
                applicationVersion: '0.1.0',
                applicationIcon: const Icon(Icons.menu_book, size: 48, color: FurColors.primary),
                children: [
                  const Text('一只可爱的英语词典~ 🦊'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
