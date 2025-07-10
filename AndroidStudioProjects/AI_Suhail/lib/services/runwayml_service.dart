import 'dart:async';

class RunwayMLService {
  // Simulate a video/image generation API call
  Future<String> generateMedia(String prompt) async {
    await Future.delayed(const Duration(seconds: 1));
    // Return a placeholder image URL for demo
    return 'https://via.placeholder.com/300x200.png?text=RunwayML+Demo';
  }
}

