import 'package:dio/dio.dart';

/// Lingva Translate — free Google Translate proxy, sentence-level translation
class TranslateApi {
  const TranslateApi._();

  static final _dio = Dio(BaseOptions(
    baseUrl: 'https://lingva.ml',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  /// Clean translation artifacts
  static String _clean(String text) {
    return text
        .replaceAll(RegExp(r'[\[\]\\]'), '')
        .trim();
  }

  /// Translate Chinese → English (full sentence)
  static Future<String> zhToEnFull(String text) async {
    if (text.isEmpty) return '';
    try {
      final resp = await _dio.get('/api/v1/zh/en/${Uri.encodeComponent(text.trim())}');
      final data = resp.data as Map<String, dynamic>;
      return _clean(data['translation']?.toString() ?? '');
    } catch (_) {
      return '';
    }
  }

  /// Translate Chinese → English, return first content word for dict lookup
  static Future<String> zhToEn(String text) async {
    if (text.isEmpty) return '';
    try {
      final resp = await _dio.get('/api/v1/zh/en/${Uri.encodeComponent(text.trim())}');
      final data = resp.data as Map<String, dynamic>;
      final full = _clean(data['translation']?.toString() ?? '');
      if (full.isEmpty) return '';
      // Find first valid English word (>1 char, no digits)
      for (final w in full.split(RegExp(r'[ ,./;:!?]+'))) {
        final clean = w.replaceAll(RegExp(r'[^a-zA-Z-]'), '');
        if (clean.length > 1) return clean.toLowerCase();
      }
      return '';
    } catch (_) {
      return '';
    }
  }

  /// Check if text contains Chinese characters
  static bool isChinese(String text) {
    return RegExp(r'[一-鿿]').hasMatch(text);
  }
}
