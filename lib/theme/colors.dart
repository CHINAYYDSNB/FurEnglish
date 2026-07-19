import 'package:flutter/material.dart';

/// FurEnglish warm/cute color scheme
class FurColors {
  FurColors._();

  // Primary palette
  static const primary = Color(0xFFF4845F); // Fox orange
  static const primaryContainer = Color(0xFFFFE0D2); // Light peach
  static const onPrimary = Color(0xFFFFFFFF); // White on primary

  // Secondary palette
  static const secondary = Color(0xFFFFB347); // Warm amber
  static const tertiary = Color(0xFFFF8DA1); // Soft pink

  // Surface / Background
  static const background = Color(0xFFFFF3E8); // Peach cream scaffold
  static const surface = Color(0xFFFFFAF5); // Warm white cards

  // Text
  static const onSurface = Color(0xFF5D4037); // Warm brown body text
  static const onSurfaceVariant = Color(0xFF8D6E63); // Lighter brown secondary

  // Borders / Decorations
  static const outline = Color(0xFFD7BBA8); // Beige taupe borders
  static const divider = Color(0xFFE8D5C4); // Light divider

  // Semantic
  static const error = Color(0xFFE57373); // Soft red
  static const success = Color(0xFF81C784); // Soft green

  // Shadows
  static Color shadow = primary.withAlpha(25); // Primary-tinted shadow

  // Gradient for buttons
  static const LinearGradient buttonGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
