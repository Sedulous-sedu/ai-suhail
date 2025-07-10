// lib/screens/claude_screen.dart
import 'package:flutter/material.dart';
import '../services/claude_service.dart';

class ClaudeScreen extends StatefulWidget {
  const ClaudeScreen({Key? key}) : super(key: key);

  @override
  State<ClaudeScreen> createState() => _ClaudeScreenState();
}

class _ClaudeScreenState extends State<ClaudeScreen> {
  final ClaudeService claudeService = ClaudeService('YOUR_ANTHROPIC_API_KEY');
  final TextEditingController _controller = TextEditingController();
  String response = '';

  void sendMessage() async {
    try {
      final result = await claudeService.sendMessage(_controller.text);
      setState(() {
        response = result;
      });
    } catch (e) {
      setState(() {
        response = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Claude Integration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Enter your message...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: sendMessage,
              child: const Text('Send'),
            ),
            const SizedBox(height: 16),
            Text(response),
          ],
        ),
      ),
    );
  }
}