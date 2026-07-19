import '../models/dictionary_entry.dart';
import 'dio_client.dart';

class DictionaryApi {
  const DictionaryApi._();

  static final _dio = DictionaryDio.instance.dio;

  /// Search word in Free Dictionary API
  /// Returns list of entries (homographs return multiple)
  static Future<List<DictionaryEntry>> search(String word) async {
    final clean = word.trim().toLowerCase();
    if (clean.isEmpty) return [];

    final resp = await _dio.get('/entries/en/$clean');

    if (resp.data is List) {
      return (resp.data as List)
          .map((e) => DictionaryEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return [];
  }
}
