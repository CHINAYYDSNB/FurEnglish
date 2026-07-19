import 'package:flutter/material.dart';
import '../theme/colors.dart';

class PhoneticBadge extends StatelessWidget {
  final String phoneticText;
  final String? audioUrl;
  final VoidCallback? onPlay;

  const PhoneticBadge({
    super.key,
    required this.phoneticText,
    this.audioUrl,
    this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    if (phoneticText.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: FurColors.background,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            phoneticText,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              color: FurColors.onSurfaceVariant,
            ),
          ),
        ),
        if (audioUrl != null && audioUrl!.isNotEmpty) ...[
          const SizedBox(width: 6),
          SizedBox(
            width: 32,
            height: 32,
            child: IconButton(
              onPressed: onPlay,
              icon: const Icon(Icons.volume_up, size: 20),
              color: FurColors.primary,
              padding: EdgeInsets.zero,
              style: IconButton.styleFrom(
                backgroundColor: FurColors.primaryContainer,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
