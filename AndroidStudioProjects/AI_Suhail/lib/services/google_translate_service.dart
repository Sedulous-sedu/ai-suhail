import 'dart:async';

class GoogleTranslateService {
  // Simulate a translation API call
  Future<String> translate(String text, String targetLang) async {
    await Future.delayed(const Duration(seconds: 1));
    // Return a mock translation for demo
    return "[Translated to $targetLang]: $text (demo)";
  }
}

