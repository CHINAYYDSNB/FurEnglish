import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dictionary_entry.dart';
import '../api/dictionary_api.dart';
import '../api/translate_api.dart';

class PhraseWord {
  final String word;
  final DictionaryEntry? entry;
  PhraseWord({required this.word, this.entry});
}

class SearchState {
  final String query;
  final List<DictionaryEntry> results;
  final List<PhraseWord> phraseWords; // multi-word results
  final bool loading;
  final String? error;
  final List<String> history;
  final String? translatedPhrase;
  final bool isChineseQuery;
  final bool isPhrase; // multi-word or sentence

  const SearchState({
    this.query = '',
    this.results = const [],
    this.phraseWords = const [],
    this.loading = false,
    this.error,
    this.history = const [],
    this.translatedPhrase,
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
    // Multi-word: has spaces, commas, or is longer than 20 characters (sentence)
    return text.contains(' ') || text.contains(',') || text.length > 20;
  }

  Future<void> search([String? word]) async {
    final q = (word ?? state.query).trim();
    if (q.isEmpty) return;

    final isCn = TranslateApi.isChinese(q);
    final isPhrase = !isCn && _isPhrase(q);
    state = state.copyWith(
      query: q,
      loading: true,
      error: null,
      isChineseQuery: isCn,
      isPhrase: isPhrase,
      translatedPhrase: null,
      results: const [],
      phraseWords: const [],
    );

    try {
      String lookupText = q;

      // Chinese input: translate first
      if (isCn) {
        final full = await TranslateApi.zhToEnFull(q);
        if (full.isNotEmpty) lookupText = full;
        state = state.copyWith(translatedPhrase: full.isNotEmpty ? full : null);
      }

      // Phrase / multi-word: split and search each word
      if (isPhrase || lookupText.contains(' ')) {
        final words = lookupText
            .split(RegExp(r'[ ,./;:!?，。；：！？]+'))
            .where((w) => w.length > 1)
            .map((w) => w.replaceAll(RegExp(r'[^a-zA-Z-]'), '').toLowerCase())
            .where((w) => w.isNotEmpty)
            .toSet()
            .take(6)
            .toList();

        final phraseWords = <PhraseWord>[];
        for (final w in words) {
          try {
            final entries = await DictionaryApi.search(w);
            phraseWords.add(PhraseWord(
              word: w,
              entry: entries.isNotEmpty ? entries.first : null,
            ));
          } catch (_) {
            phraseWords.add(PhraseWord(word: w));
          }
        }

        final history = [q, ...state.history.where((h) => h != q)].take(10).toList();
        state = state.copyWith(phraseWords: phraseWords, loading: false, history: history);
        return;
      }

      // Single English word: normal lookup
      final results = await DictionaryApi.search(lookupText);
      final history = [q, ...state.history.where((h) => h != q)].take(10).toList();
      state = state.copyWith(
        results: results,
        loading: false,
        history: history,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  void clearResults() {
    state = state.copyWith(results: [], phraseWords: [], query: '', error: null);
  }
}

final searchProvider =
    StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier();
});
