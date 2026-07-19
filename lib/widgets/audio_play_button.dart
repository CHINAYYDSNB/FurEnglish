import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/tts_provider.dart';
import '../theme/colors.dart';

class AudioPlayButton extends ConsumerWidget {
  final String text;
  final double size;

  const AudioPlayButton({
    super.key,
    required this.text,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ttsState = ref.watch(ttsProvider);

    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: FurColors.primaryContainer,
        borderRadius: BorderRadius.circular(size / 2),
        child: InkWell(
          borderRadius: BorderRadius.circular(size / 2),
          onTap: () {
            if (ttsState.isSpeaking) {
              ref.read(ttsProvider.notifier).stop();
            } else {
              ref.read(ttsProvider.notifier).speak(text);
            }
          },
          child: Icon(
            ttsState.isSpeaking ? Icons.stop : Icons.volume_up_rounded,
            size: size * 0.55,
            color: FurColors.primary,
          ),
        ),
      ),
    );
  }
}
