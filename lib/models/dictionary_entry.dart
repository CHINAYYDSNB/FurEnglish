import 'package:json_annotation/json_annotation.dart';

part 'dictionary_entry.g.dart';

@JsonSerializable()
class DictionaryEntry {
  final String word;
  final String? phonetic;
  final List<Phonetic> phonetics;
  final String? origin;
  final List<Meaning> meanings;

  const DictionaryEntry({
    required this.word,
    this.phonetic,
    this.phonetics = const [],
    this.origin,
    this.meanings = const [],
  });

  factory DictionaryEntry.fromJson(Map<String, dynamic> json) =>
      _$DictionaryEntryFromJson(json);
  Map<String, dynamic> toJson() => _$DictionaryEntryToJson(this);

  String get bestPhonetic =>
      phonetic ?? phonetics.firstOrNull?.text ?? '';

  String get bestAudioUrl =>
      phonetics.firstWhere((p) => p.audio?.isNotEmpty == true,
          orElse: () => const Phonetic()).audio ?? '';
}

@JsonSerializable()
class Phonetic {
  final String? text;
  final String? audio;
  final String? sourceUrl;
  final License? license;

  const Phonetic({this.text, this.audio, this.sourceUrl, this.license});

  factory Phonetic.fromJson(Map<String, dynamic> json) =>
      _$PhoneticFromJson(json);
  Map<String, dynamic> toJson() => _$PhoneticToJson(this);
}

@JsonSerializable()
class License {
  final String name;
  final String url;

  const License({required this.name, required this.url});

  factory License.fromJson(Map<String, dynamic> json) =>
      _$LicenseFromJson(json);
  Map<String, dynamic> toJson() => _$LicenseToJson(this);
}

@JsonSerializable()
class Meaning {
  final String partOfSpeech;
  final List<Definition> definitions;
  final List<String> synonyms;
  final List<String> antonyms;

  const Meaning({
    required this.partOfSpeech,
    this.definitions = const [],
    this.synonyms = const [],
    this.antonyms = const [],
  });

  factory Meaning.fromJson(Map<String, dynamic> json) =>
      _$MeaningFromJson(json);
  Map<String, dynamic> toJson() => _$MeaningToJson(this);
}

@JsonSerializable()
class Definition {
  final String definition;
  final String? example;
  final List<String> synonyms;
  final List<String> antonyms;

  const Definition({
    required this.definition,
    this.example,
    this.synonyms = const [],
    this.antonyms = const [],
  });

  factory Definition.fromJson(Map<String, dynamic> json) =>
      _$DefinitionFromJson(json);
  Map<String, dynamic> toJson() => _$DefinitionToJson(this);

  String get firstSynonym => synonyms.isNotEmpty ? synonyms.first : '';
  String get firstAntonym => antonyms.isNotEmpty ? antonyms.first : '';
}
