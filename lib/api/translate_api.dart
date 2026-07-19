import 'package:dio/dio.dart';

/// MyMemory translation API — free, no key required
class TranslateApi {
  const TranslateApi._();

  static final _dio = Dio(BaseOptions(
    baseUrl: 'https://api.mymemory.translated.net',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  /// Translate Chinese → English, return first word only (dictionary-friendly)
  static Future<String> zhToEn(String text) async {
    if (text.isEmpty) return '';
    try {
      final resp = await _dio.get('/get', queryParameters: {
        'q': text.trim(),
        'langpair': 'zh|en',
      });
      final data = resp.data as Map<String, dynamic>;
      final full = data['responseData']?['translatedText']?.toString() ?? '';
      if (full.isEmpty) return '';
      // Take first word only for dictionary lookup
      return full.split(RegExp(r'[ ,./;]')).first;
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
      return data['responseData']?['translatedText']?.toString() ?? '';
    } catch (_) {
      return '';
    }
  }

  /// Check if text contains Chinese characters
  static bool isChinese(String text) {
    return RegExp(r'[一-鿿]').hasMatch(text);
  }
}
