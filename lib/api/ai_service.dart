import 'dart:convert';
import 'package:dio/dio.dart';
import 'api_keys.dart';

class AiService {
  const AiService._();

  static final _dio = Dio(BaseOptions(
    baseUrl: 'https://api.deepseek.com/v1',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Authorization': 'Bearer $kDeepSeekKey',
      'Content-Type': 'application/json',
    },
  ));

  /// Analyze a Chinese sentence: return English translation + phrase breakdown
  /// Returns: { "translation": "...", "phrases": ["phrase1", "phrase2", ...] }
  static Future<Map<String, dynamic>> analyzeSentence(String text) async {
    try {
      final resp = await _dio.post('/chat/completions', data: {
        'model': 'deepseek-chat',
        'messages': [
          {
            'role': 'system',
            'content': '''You are an English learning assistant. Given a Chinese sentence:
1. Translate it to natural English
2. Break the English translation into meaningful phrases (3-6 words each)
Return ONLY valid JSON:
{"translation": "full English translation", "phrases": ["phrase 1", "phrase 2"]}'''
          },
          {'role': 'user', 'content': text},
        ],
        'temperature': 0.3,
        'max_tokens': 500,
      });
      final data = resp.data as Map<String, dynamic>;
      final content = data['choices']?[0]?['message']?['content']?.toString() ?? '';
      // Extract JSON from response
      final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(content);
      if (jsonMatch != null) {
        return jsonDecode(jsonMatch.group(0)!) as Map<String, dynamic>;
      }
      return {'translation': '', 'phrases': <String>[]};
    } catch (e) {
      return {'translation': '', 'phrases': <String>[]};
    }
  }
}
