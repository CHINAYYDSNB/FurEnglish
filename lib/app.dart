import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'theme/components.dart';
import 'pages/home_page.dart';
import 'pages/search_page.dart';
import 'pages/word_detail_page.dart';
import 'pages/word_book_page.dart';
import 'pages/review_page.dart';
import 'pages/ocr_camera_page.dart';
import 'pages/settings_page.dart';

final _router = GoRouter(
  initialLocation: '/search',
  routes: [
    ShellRoute(
      builder: (context, state, child) => HomePage(child: child),
      routes: [
        GoRoute(
          path: '/search',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SearchPage(),
          ),
        ),
        GoRoute(
          path: '/word-book',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: WordBookPage(),
          ),
        ),
        GoRoute(
          path: '/review',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ReviewPage(),
          ),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SettingsPage(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/word/:word',
      builder: (context, state) => WordDetailPage(
        word: state.pathParameters['word']!,
      ),
    ),
    GoRoute(
      path: '/ocr',
      builder: (context, state) => const OcrCameraPage(),
    ),
  ],
);

class FurEnglishApp extends StatelessWidget {
  const FurEnglishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FurEnglish',
      debugShowCheckedModeBanner: false,
      theme: buildFurTheme(),
      routerConfig: _router,
    );
  }
}
