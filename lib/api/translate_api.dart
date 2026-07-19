import 'package:dio/dio.dart';

/// Google Translate unofficial API — sentence-level, no key
class TranslateApi {
  const TranslateApi._();

  static final _dio = Dio(BaseOptions(
    baseUrl: 'https://lingva.lanxis.top',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  /// Translate Chinese → English (full sentence)
  static Future<String> zhToEnFull(String text) async {
    if (text.isEmpty) return '';
    try {
      final resp = await _dio.get('/translate_a/single', queryParameters: {
        'client': 'gtx',
        'sl': 'zh-CN',
        'tl': 'en',
        'dt': 't',
        'q': text.trim(),
      });
      final data = resp.data as List;
      final buf = StringBuffer();
      for (final block in data[0] as List) {
        buf.write(block[0]);
      }
      return buf.toString().trim();
    } catch (_) {
      return '';
    }
  }

  /// Translate Chinese → English, return first content word
  static Future<String> zhToEn(String text) async {
    final full = await zhToEnFull(text);
    if (full.isEmpty) return '';
    for (final w in full.split(RegExp(r'[ ,./;:!?]+'))) {
      final clean = w.replaceAll(RegExp(r'[^a-zA-Z-]'), '');
      if (clean.length > 1) return clean.toLowerCase();
    }
    return '';
  }

  static Future<String> enToZh(String text) async {
    if (text.isEmpty) return '';
    try {
      final resp = await _dio.get('/translate_a/single', queryParameters: {
        'client': 'gtx',
        'sl': 'en',
        'tl': 'zh-CN',
        'dt': 't',
        'q': text.trim(),
      });
      final data = resp.data as List;
      final buf = StringBuffer();
      for (final block in data[0] as List) {
        buf.write(block[0]);
      }
      return buf.toString().trim();
    } catch (_) {
      return '';
    }
  }

  static bool isChinese(String text) {
    return RegExp(r'[一-鿿]').hasMatch(text);
  }
}
