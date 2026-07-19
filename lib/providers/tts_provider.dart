import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TtsState {
  final bool isSpeaking;
  final double rate;

  const TtsState({this.isSpeaking = false, this.rate = 0.5});

  TtsState copyWith({bool? isSpeaking, double? rate}) =>
      TtsState(isSpeaking: isSpeaking ?? this.isSpeaking, rate: rate ?? this.rate);
}

class TtsNotifier extends StateNotifier<TtsState> {
  final FlutterTts _tts = FlutterTts();

  TtsNotifier() : super(const TtsState()) {
    _tts.setLanguage('en-US');
    _tts.setSpeechRate(state.rate);
    _tts.setStartHandler(() => state = state.copyWith(isSpeaking: true));
    _tts.setCompletionHandler(() => state = state.copyWith(isSpeaking: false));
    _tts.setErrorHandler((msg) => state = state.copyWith(isSpeaking: false));
  }

  Future<void> speak(String text) async {
    if (text.isEmpty) return;
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
    state = state.copyWith(isSpeaking: false);
  }

  Future<void> setRate(double rate) async {
    state = state.copyWith(rate: rate);
    await _tts.setSpeechRate(rate);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }
}

final ttsProvider = StateNotifierProvider<TtsNotifier, TtsState>((ref) {
  return TtsNotifier();
});
