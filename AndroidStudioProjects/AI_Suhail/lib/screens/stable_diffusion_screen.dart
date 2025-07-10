import 'package:flutter/material.dart';
import '../services/stable_diffusion_service.dart';

class StableDiffusionScreen extends StatefulWidget {
  const StableDiffusionScreen({Key? key}) : super(key: key);

  @override
  State<StableDiffusionScreen> createState() => _StableDiffusionScreenState();
}

class _StableDiffusionScreenState extends State<StableDiffusionScreen> {
  final StableDiffusionService stableDiffusionService = StableDiffusionService();
  final TextEditingController _controller = TextEditingController();
  String? imageUrl;
  bool loading = false;

  void generateImage() async {
    setState(() {
      loading = true;
      imageUrl = null;
    });
    try {
      final url = await stableDiffusionService.generateImage(_controller.text);
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
      appBar: AppBar(title: const Text('Stable Diffusion (Demo)')),
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

