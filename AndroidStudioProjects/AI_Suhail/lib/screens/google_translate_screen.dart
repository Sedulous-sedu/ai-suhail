import 'package:flutter/material.dart';
import '../services/google_translate_service.dart';

class GoogleTranslateScreen extends StatefulWidget {
  const GoogleTranslateScreen({super.key});

  @override
  State<GoogleTranslateScreen> createState() => _GoogleTranslateScreenState();
}

class _GoogleTranslateScreenState extends State<GoogleTranslateScreen> {
  final GoogleTranslateService translateService = GoogleTranslateService();
  final TextEditingController _controller = TextEditingController();
  String? translation;
  String targetLang = 'es';
  bool loading = false;

  void translate() async {
    setState(() {
      loading = true;
      translation = null;
    });
    try {
      final result = await translateService.translate(_controller.text, targetLang);
      setState(() {
        translation = result;
        loading = false;
      });
    } catch (e) {
      setState(() {
        translation = null;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Translate API (Demo)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Enter text to translate...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: targetLang,
              items: const [
                DropdownMenuItem(value: 'es', child: Text('Spanish')),
                DropdownMenuItem(value: 'fr', child: Text('French')),
                DropdownMenuItem(value: 'de', child: Text('German')),
                DropdownMenuItem(value: 'hi', child: Text('Hindi')),
              ],
              onChanged: (val) => setState(() => targetLang = val ?? 'es'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: translate,
              child: const Text('Translate'),
            ),
            const SizedBox(height: 16),
            if (loading) const CircularProgressIndicator(),
            if (translation != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(translation!, style: const TextStyle(fontSize: 18)),
              ),
          ],
        ),
      ),
    );
  }
}
