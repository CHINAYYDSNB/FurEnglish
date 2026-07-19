import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_keys.dart';

class AiService {
  const AiService._();

  static final _dio = Dio(BaseOptions(
    baseUrl: 'https://api.deepseek.com/v1',
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 90),
    headers: {
      'Authorization': 'Bearer $kDeepSeekKey',
      'Content-Type': 'application/json',
    },
  ));

  /// Analyze Chinese text → English translation + phrase breakdown
  static Future<Map<String, dynamic>> analyzeSentence(String text) async {
    try {
      final resp = await _dio.post('/chat/completions', data: {
        'model': 'deepseek-chat',
        'temperature': 0.3,
        'max_tokens': 4096,
        'messages': [
          {
            'role': 'system',
            'content': 'You are an English learning assistant.\n1. Translate the Chinese text into natural, flowing English.\n2. Split the ENGLISH translation (NOT the Chinese) into meaningful phrase groups of 3-6 English words each.\n3. Return ONLY valid JSON, no markdown:\n{"translation": "the full English translation", "phrases": ["english phrase 1", "english phrase 2", "english phrase 3"]}'
          },
          {'role': 'user', 'content': text},
        ],
      });

      final data = resp.data as Map<String, dynamic>;
      var content = data['choices']?[0]?['message']?['content']?.toString() ?? '';

      content = content
          .replaceAll(RegExp(r'```json\s*'), '')
          .replaceAll(RegExp(r'```\s*'), '')
          .trim();

      final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(content);
      if (jsonMatch != null) {
        return jsonDecode(jsonMatch.group(0)!) as Map<String, dynamic>;
      }

      debugPrint('AiService: no JSON in response');
      return {'translation': content, 'phrases': <String>[]};
    } catch (e) {
      debugPrint('AiService error: $e');
      return {'translation': '', 'phrases': <String>[]};
    }
  }
}
