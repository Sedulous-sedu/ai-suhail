import 'dart:async';

class TabnineService {
  // Simulate a code suggestion API call
  Future<String> getSuggestion(String prompt) async {
    await Future.delayed(const Duration(seconds: 1));
    return "[Tabnine Suggestion]: // Demo code for '$prompt'";
  }
}

