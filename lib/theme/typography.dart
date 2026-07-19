import 'package:flutter/material.dart' show TextTheme, TextStyle, FontWeight;
import 'colors.dart';

/// FurEnglish text theme — Fredoka for headlines, Nunito for body
TextTheme buildFurTextTheme() {
  return const TextTheme(
    // Word on detail page
    displayLarge: TextStyle(
      fontFamily: 'Fredoka',
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: FurColors.onSurface,
    ),
    // Section titles
    headlineMedium: TextStyle(
      fontFamily: 'Fredoka',
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: FurColors.onSurface,
    ),
    // Card titles
    titleLarge: TextStyle(
      fontFamily: 'Fredoka',
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: FurColors.onSurface,
    ),
    // Part-of-speech badges
    titleMedium: TextStyle(
      fontFamily: 'Nunito',
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: FurColors.onSurface,
    ),
    // Definition text
    bodyLarge: TextStyle(
      fontFamily: 'Nunito',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: FurColors.onSurface,
    ),
    // Example sentences, secondary info
    bodyMedium: TextStyle(
      fontFamily: 'Nunito',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: FurColors.onSurfaceVariant,
    ),
    // Button labels
    labelLarge: TextStyle(
      fontFamily: 'Nunito',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: FurColors.onPrimary,
    ),
    // Phonetic text, captions
    labelSmall: TextStyle(
      fontFamily: 'Nunito',
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: FurColors.onSurfaceVariant,
    ),
  );
}
