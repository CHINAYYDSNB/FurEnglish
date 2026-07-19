/// Split English text into meaningful phrase groups (3-6 words each)
List<String> splitIntoPhrases(String text) {
  if (text.isEmpty) return [];

  // Step 1: split by punctuation
  final rough = text.split(RegExp(r'[,;:—–()]'));
  final phrases = <String>[];

  for (final segment in rough) {
    final trimmed = segment.trim();
    if (trimmed.isEmpty) continue;

    final words = trimmed.split(' ').where((w) => w.isNotEmpty).toList();
    if (words.length <= 5) {
      phrases.add(trimmed);
    } else {
      // Step 2: split long segments at function words
      phrases.addAll(_splitLongSegment(words));
    }
  }

  return phrases.where((p) => p.isNotEmpty).toList();
}

/// Split a long word list at natural phrase boundaries
List<String> _splitLongSegment(List<String> words) {
  final breakWords = {
    'of', 'in', 'on', 'at', 'by', 'for', 'with', 'from', 'to',
    'through', 'before', 'after', 'during', 'across', 'into',
    'and', 'or', 'that', 'which', 'who', 'whose', 'where', 'when',
    'as', 'but', 'so', 'if', 'while', 'although', 'though',
  };

  final result = <String>[];
  var chunk = <String>[];
  var chunkLen = 0;

  for (var i = 0; i < words.length; i++) {
    final w = words[i];
    final clean = w.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');

    // Break at function words when chunk is big enough
    if (chunkLen >= 3 && breakWords.contains(clean) && i < words.length - 1) {
      result.add(chunk.join(' '));
      chunk = [];
      chunkLen = 0;
    }

    chunk.add(w);
    chunkLen++;

    // Force break at 6 words
    if (chunkLen >= 6) {
      result.add(chunk.join(' '));
      chunk = [];
      chunkLen = 0;
    }
  }

  if (chunk.isNotEmpty) result.add(chunk.join(' '));
  return result;
}

/// Extract the most meaningful lookup word from a phrase
String phraseKeyWord(String phrase) {
  final stopWords = {
    'the', 'a', 'an', 'is', 'are', 'was', 'were', 'be', 'been', 'am',
    'of', 'to', 'in', 'on', 'at', 'for', 'with', 'it', 'and', 'or',
    'that', 'this', 'these', 'those', 'do', 'does', 'did', 'has', 'have',
    'had', 'will', 'would', 'can', 'could', 'may', 'might', 'shall', 'should',
    'not', 'no', 'but', 'so', 'if', 'as', 'by', 'from', 'its', 'their',
    'he', 'she', 'they', 'we', 'you', 'i', 'me', 'him', 'her', 'us', 'them',
    'my', 'your', 'his', 'our', 'all', 'some', 'any', 'each', 'every',
    'who', 'whom', 'whose', 'which', 'what', 'when', 'where', 'how',
    'while', 'although', 'though', 'because', 'since', 'until',
    'just', 'only', 'very', 'then', 'now', 'also', 'still', 'already',
  };

  final words = phrase
      .split(RegExp(r'[ ,./;:!?]+'))
      .map((w) => w.replaceAll(RegExp(r'[^a-zA-Z-]'), '').toLowerCase())
      .where((w) => w.length > 2 && !stopWords.contains(w))
      .toList();

  // Return longest content word
  if (words.isEmpty) {
    // Fallback: first non-stop word
    final all = phrase.split(' ').where((w) => w.length > 1).toList();
    return all.isNotEmpty ? all.first.replaceAll(RegExp(r'[^a-zA-Z]'), '').toLowerCase() : '';
  }
  words.sort((a, b) => b.length.compareTo(a.length));
  return words.first;
}
