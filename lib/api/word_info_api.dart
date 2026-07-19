import 'package:dio/dio.dart';

/// Additional word info: roots, affixes, related words
/// Uses Datamuse API (free, no key)
class WordInfoApi {
  const WordInfoApi._();

  static final _dio = Dio(BaseOptions(
    baseUrl: 'https://api.datamuse.com',
    connectTimeout: const Duration(seconds: 8),
    receiveTimeout: const Duration(seconds: 8),
  ));

  /// Get word root/etymology info
  /// Returns list of {word, score, tags}
  static Future<List<Map<String, dynamic>>> getRelated(String word) async {
    try {
      final resp = await _dio.get('/words', queryParameters: {
        'sp': word.trim().toLowerCase(),
        'md': 'r', // metadata: roots/related
        'max': 5,
      });
      return (resp.data as List).cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  /// Extract root words from Datamuse response tags
  static List<String> extractRoots(List<Map<String, dynamic>> data) {
    final roots = <String>{};
    for (final item in data) {
      final tags = item['tags'] as List?;
      if (tags == null) continue;
      for (final tag in tags) {
        final t = tag.toString();
        if (t.startsWith('syn:') || t.startsWith('rel:')) {
          roots.add(t.substring(4));
        }
      }
    }
    return roots.take(8).toList();
  }
}
