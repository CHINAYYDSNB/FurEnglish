import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dictionary_entry.dart';
import '../api/dictionary_api.dart';

class SearchState {
  final String query;
  final List<DictionaryEntry> results;
  final bool loading;
  final String? error;
  final List<String> history; // last 10 queries

  const SearchState({
    this.query = '',
    this.results = const [],
    this.loading = false,
    this.error,
    this.history = const [],
  });

  SearchState copyWith({
    String? query,
    List<DictionaryEntry>? results,
    bool? loading,
    String? error,
    List<String>? history,
  }) =>
      SearchState(
        query: query ?? this.query,
        results: results ?? this.results,
        loading: loading ?? this.loading,
        error: error,
        history: history ?? this.history,
      );
}

class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier() : super(const SearchState());

  void updateQuery(String q) {
    state = state.copyWith(query: q, error: null);
  }

  Future<void> search([String? word]) async {
    final q = (word ?? state.query).trim();
    if (q.isEmpty) return;

    state = state.copyWith(query: q, loading: true, error: null);

    try {
      final results = await DictionaryApi.search(q);
      final history = [q, ...state.history.where((h) => h != q)].take(10).toList();
      state = state.copyWith(
        results: results,
        loading: false,
        history: history,
      );
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: e.toString(),
      );
    }
  }

  void clearResults() {
    state = state.copyWith(results: [], query: '', error: null);
  }
}

final searchProvider =
    StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier();
});
