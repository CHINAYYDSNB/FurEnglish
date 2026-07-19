import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dictionary_entry.dart';
import '../api/dictionary_api.dart';
import '../api/translate_api.dart';
import '../api/ai_service.dart';

class SearchState {
  final String query;
  final List<DictionaryEntry> results;
  final List<PhraseWord> phraseWords;
  final bool loading;
  final String? error;
  final List<String> history;
  final String? translatedPhrase;
  final List<String> aiPhrases; // DeepSeek phrase breakdown
  final bool isChineseQuery;
  final bool isPhrase;

  const SearchState({
    this.query = '',
    this.results = const [],
    this.phraseWords = const [],
    this.loading = false,
    this.error,
    this.history = const [],
    this.translatedPhrase,
    this.aiPhrases = const [],
    this.isChineseQuery = false,
    this.isPhrase = false,
  });

  SearchState copyWith({
    String? query,
    List<DictionaryEntry>? results,
    List<PhraseWord>? phraseWords,
    bool? loading,
    String? error,
    List<String>? history,
    String? translatedPhrase,
    List<String>? aiPhrases,
    bool? isChineseQuery,
    bool? isPhrase,
  }) =>
      SearchState(
        query: query ?? this.query,
        results: results ?? this.results,
        phraseWords: phraseWords ?? this.phraseWords,
        loading: loading ?? this.loading,
        error: error,
        history: history ?? this.history,
        translatedPhrase: translatedPhrase,
        aiPhrases: aiPhrases ?? this.aiPhrases,
        isChineseQuery: isChineseQuery ?? this.isChineseQuery,
        isPhrase: isPhrase ?? this.isPhrase,
      );
}

class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier() : super(const SearchState());

  void updateQuery(String q) {
    state = state.copyWith(query: q, error: null);
  }

  static bool _isPhrase(String text) {
    return text.contains(' ') || text.contains(',') || text.length > 20;
  }

  Future<void> search([String? word]) async {
    final q = (word ?? state.query).trim();
    if (q.isEmpty) return;

    final isCn = TranslateApi.isChinese(q);
    state = state.copyWith(
      query: q,
      loading: true,
      error: null,
      isChineseQuery: isCn,
      isPhrase: false,
      translatedPhrase: null,
      results: const [],
    );

    try {
      // ── Chinese: DeepSeek translate + phrase split ──
      if (isCn) {
        final result = await AiService.analyzeSentence(q);
        final translation = result['translation']?.toString() ?? '';
        final phrases = (result['phrases'] as List?)
            ?.map((p) => p.toString())
            .where((p) => p.isNotEmpty)
            .toList() ?? <String>[];
        final history = [q, ...state.history.where((h) => h != q)].take(10).toList();
        state = state.copyWith(
          translatedPhrase: translation.isNotEmpty ? translation : '翻译失败',
          aiPhrases: phrases,
          loading: false,
          history: history,
        );
        return;
      }

      // ── English phrase: split and search each word ──
      if (_isPhrase(q)) {
        final words = q
            .split(RegExp(r'[ ,./;:!?，。；：！？]+'))
            .map((w) => w.replaceAll(RegExp(r'[^a-zA-Z-]'), '').toLowerCase())
            .where((w) => w.isNotEmpty && w.length > 1)
            .toSet()
            .take(6)
            .toList();

        final phraseWords = <PhraseWord>[];
        for (final w in words) {
          try {
            final entries = await DictionaryApi.search(w);
            phraseWords.add(PhraseWord(word: w, entry: entries.isNotEmpty ? entries.first : null));
          } catch (_) {
            phraseWords.add(PhraseWord(word: w));
          }
        }
        final history = [q, ...state.history.where((h) => h != q)].take(10).toList();
        state = state.copyWith(
          isPhrase: true,
          phraseWords: phraseWords,
          loading: false,
          history: history,
        );
        return;
      }

      // ── English single word: normal dictionary lookup ──
      final results = await DictionaryApi.search(q);
      final history = [q, ...state.history.where((h) => h != q)].take(10).toList();
      state = state.copyWith(results: results, loading: false, history: history);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  void clearResults() {
    state = state.copyWith(results: [], phraseWords: [], query: '', error: null);
  }
}

class PhraseWord {
  final String word;
  final DictionaryEntry? entry;
  PhraseWord({required this.word, this.entry});
}

final searchProvider =
    StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier();
});
