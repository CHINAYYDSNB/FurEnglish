import 'package:flutter/material.dart';
import 'colors.dart';

/// FurEnglish component theme — rounded corners, soft shadows, warm feel
ThemeData buildFurTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: FurColors.primary,
      onPrimary: FurColors.onPrimary,
      primaryContainer: FurColors.primaryContainer,
      secondary: FurColors.secondary,
      tertiary: FurColors.tertiary,
      surface: FurColors.surface,
      onSurface: FurColors.onSurface,
      onSurfaceVariant: FurColors.onSurfaceVariant,
      outline: FurColors.outline,
      error: FurColors.error,
    ),
    scaffoldBackgroundColor: FurColors.background,
    textTheme: _furTextTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: FurColors.background,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Fredoka',
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: FurColors.onSurface,
      ),
    ),
    cardTheme: CardThemeData(
      color: FurColors.surface,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        side: BorderSide(color: FurColors.divider, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: FurColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: FurColors.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: FurColors.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: FurColors.primary, width: 2),
      ),
      hintStyle: const TextStyle(
        fontFamily: 'Nunito',
        color: FurColors.onSurfaceVariant,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: FurColors.primary,
        foregroundColor: FurColors.onPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        textStyle: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: FurColors.primary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        textStyle: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: FurColors.primaryContainer,
      labelStyle: const TextStyle(
        fontFamily: 'Nunito',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: FurColors.primary,
      ),
      shape: const StadiumBorder(),
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: FurColors.surface,
      indicatorColor: FurColors.primaryContainer,
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(
          fontFamily: 'Nunito',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: FurColors.primary,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: FurColors.primary);
        }
        return const IconThemeData(color: FurColors.onSurfaceVariant);
      }),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shadowColor: FurColors.shadow,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: FurColors.surface,
      selectedItemColor: FurColors.primary,
      unselectedItemColor: FurColors.onSurfaceVariant,
      type: BottomNavigationBarType.fixed,
    ),
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
  );
}

final _furTextTheme = TextTheme(
  displayLarge: const TextStyle(
    fontFamily: 'Fredoka',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: FurColors.onSurface,
  ),
  headlineMedium: const TextStyle(
    fontFamily: 'Fredoka',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: FurColors.onSurface,
  ),
  titleLarge: const TextStyle(
    fontFamily: 'Fredoka',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: FurColors.onSurface,
  ),
  titleMedium: const TextStyle(
    fontFamily: 'Nunito',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: FurColors.onSurface,
  ),
  bodyLarge: const TextStyle(
    fontFamily: 'Nunito',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: FurColors.onSurface,
  ),
  bodyMedium: const TextStyle(
    fontFamily: 'Nunito',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: FurColors.onSurfaceVariant,
  ),
  labelLarge: const TextStyle(
    fontFamily: 'Nunito',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: FurColors.onPrimary,
  ),
  labelSmall: const TextStyle(
    fontFamily: 'Nunito',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: FurColors.onSurfaceVariant,
  ),
);
