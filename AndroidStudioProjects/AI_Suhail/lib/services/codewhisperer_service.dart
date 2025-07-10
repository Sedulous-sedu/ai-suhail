import 'dart:async';

class CodeWhispererService {
  // Simulate a code suggestion API call
  Future<String> getSuggestion(String prompt) async {
    await Future.delayed(const Duration(seconds: 1));
    return "[CodeWhisperer Suggestion]: // Demo code for '$prompt'";
  }
}

