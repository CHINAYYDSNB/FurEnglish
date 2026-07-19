// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dictionary_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DictionaryEntry _$DictionaryEntryFromJson(Map<String, dynamic> json) =>
    DictionaryEntry(
      word: json['word'] as String,
      phonetic: json['phonetic'] as String?,
      phonetics:
          (json['phonetics'] as List<dynamic>?)
              ?.map((e) => Phonetic.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      origin: json['origin'] as String?,
      meanings:
          (json['meanings'] as List<dynamic>?)
              ?.map((e) => Meaning.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DictionaryEntryToJson(DictionaryEntry instance) =>
    <String, dynamic>{
      'word': instance.word,
      'phonetic': instance.phonetic,
      'phonetics': instance.phonetics,
      'origin': instance.origin,
      'meanings': instance.meanings,
    };

Phonetic _$PhoneticFromJson(Map<String, dynamic> json) => Phonetic(
  text: json['text'] as String?,
  audio: json['audio'] as String?,
  sourceUrl: json['sourceUrl'] as String?,
  license: json['license'] == null
      ? null
      : License.fromJson(json['license'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PhoneticToJson(Phonetic instance) => <String, dynamic>{
  'text': instance.text,
  'audio': instance.audio,
  'sourceUrl': instance.sourceUrl,
  'license': instance.license,
};

License _$LicenseFromJson(Map<String, dynamic> json) =>
    License(name: json['name'] as String, url: json['url'] as String);

Map<String, dynamic> _$LicenseToJson(License instance) => <String, dynamic>{
  'name': instance.name,
  'url': instance.url,
};

Meaning _$MeaningFromJson(Map<String, dynamic> json) => Meaning(
  partOfSpeech: json['partOfSpeech'] as String,
  definitions:
      (json['definitions'] as List<dynamic>?)
          ?.map((e) => Definition.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  synonyms:
      (json['synonyms'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  antonyms:
      (json['antonyms'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$MeaningToJson(Meaning instance) => <String, dynamic>{
  'partOfSpeech': instance.partOfSpeech,
  'definitions': instance.definitions,
  'synonyms': instance.synonyms,
  'antonyms': instance.antonyms,
};

Definition _$DefinitionFromJson(Map<String, dynamic> json) => Definition(
  definition: json['definition'] as String,
  example: json['example'] as String?,
  synonyms:
      (json['synonyms'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  antonyms:
      (json['antonyms'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$DefinitionToJson(Definition instance) =>
    <String, dynamic>{
      'definition': instance.definition,
      'example': instance.example,
      'synonyms': instance.synonyms,
      'antonyms': instance.antonyms,
    };
