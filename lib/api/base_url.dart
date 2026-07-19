import 'package:flutter/foundation.dart';

String _host(String webPath, String mobileHost) {
  if (kIsWeb) return 'http://localhost:3000$webPath';
  return 'https://$mobileHost';
}

String dictBaseUrl() => _host('/dict', 'api.lanxis.top');
String translateBaseUrl() => _host('/translate', 'lingva.lanxis.top');
String datamuseBaseUrl() => _host('/words', 'datamuse.lanxis.top');
