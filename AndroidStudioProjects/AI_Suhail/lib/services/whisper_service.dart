import 'dart:async';

class WhisperService {
  // Simulate a speech-to-text API call
  Future<String> transcribe(String audioPath) async {
    await Future.delayed(const Duration(seconds: 1));
    // Return a mock transcription for demo
    return "[Whisper transcription of audio] (demo)";
  }
}

