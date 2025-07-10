import 'package:flutter/material.dart';
import '../services/midjourney_service.dart';

class MidjourneyScreen extends StatefulWidget {
  const MidjourneyScreen({super.key});

  @override
  State<MidjourneyScreen> createState() => _MidjourneyScreenState();
}

class _MidjourneyScreenState extends State<MidjourneyScreen> {
  final MidjourneyService midjourneyService = MidjourneyService();
  final TextEditingController _controller = TextEditingController();
  String? imageUrl;
  bool loading = false;

  void generateImage() async {
    setState(() {
      loading = true;
      imageUrl = null;
    });
    try {
      final url = await midjourneyService.generateImage(_controller.text);
      setState(() {
        imageUrl = url;
        loading = false;
      });
    } catch (e) {
      setState(() {
        imageUrl = null;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Midjourney (Demo)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Describe your image...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: generateImage,
              child: const Text('Generate Image'),
            ),
            const SizedBox(height: 16),
            if (loading) const CircularProgressIndicator(),
            if (imageUrl != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(imageUrl!),
              ),
          ],
        ),
      ),
    );
  }
}
