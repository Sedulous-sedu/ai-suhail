import 'package:flutter/material.dart';
import '../services/bard_service.dart';

class BardScreen extends StatefulWidget {
  const BardScreen({Key? key}) : super(key: key);

  @override
  State<BardScreen> createState() => _BardScreenState();
}

class _BardScreenState extends State<BardScreen> {
  final BardService bardService = BardService();
  final TextEditingController _controller = TextEditingController();
  String response = '';

  void sendMessage() async {
    setState(() {
      response = 'Loading...';
    });
    try {
      final result = await bardService.sendMessage(_controller.text);
      setState(() {
        response = result;
      });
    } catch (e) {
      setState(() {
        response = 'Error: '
            '[31m$e[0m';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bard (Google AI) Demo')),
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
