import 'package:dio/dio.dart';

/// MyMemory translation API — free, no key required
class TranslateApi {
  const TranslateApi._();

  static final _dio = Dio(BaseOptions(
    baseUrl: 'https://api.mymemory.translated.net',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  /// Clean MyMemory translation artifacts
  static String _clean(String text) {
    return text
        .replaceAll(RegExp(r'[\[\]\\]'), '') // strip [ ] \
        .trim();
  }

  /// Translate Chinese → English, return first alpha-word for dictionary lookup
  static Future<String> zhToEn(String text) async {
    if (text.isEmpty) return '';
    try {
      final resp = await _dio.get('/get', queryParameters: {
        'q': text.trim(),
        'langpair': 'zh|en',
      });
      final data = resp.data as Map<String, dynamic>;
      final full = _clean(data['responseData']?['translatedText']?.toString() ?? '');
      if (full.isEmpty) return '';
      // Split and find first valid English word (no digits/symbols)
      final words = full.split(RegExp(r'[ ,./;:!?]+'));
      for (final w in words) {
        final clean = w.replaceAll(RegExp(r'[^a-zA-Z-]'), '');
        if (clean.isNotEmpty && clean.length > 1) return clean.toLowerCase();
      }
      return '';
    } catch (_) {
      return '';
    }
  }

  /// Full translation (multi-word), for display purposes
  static Future<String> zhToEnFull(String text) async {
    if (text.isEmpty) return '';
    try {
      final resp = await _dio.get('/get', queryParameters: {
        'q': text.trim(),
        'langpair': 'zh|en',
      });
      final data = resp.data as Map<String, dynamic>;
      return _clean(data['responseData']?['translatedText']?.toString() ?? '');
    } catch (_) {
      return '';
    }
  }

  /// Check if text contains Chinese characters
  static bool isChinese(String text) {
    return RegExp(r'[一-鿿]').hasMatch(text);
  }
}
