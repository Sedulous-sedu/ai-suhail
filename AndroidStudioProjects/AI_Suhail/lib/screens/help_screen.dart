import 'package:flutter/material.dart';
import '../models/tutorial.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatelessWidget {
  final List<Tutorial> tutorials = [
    Tutorial(
      title: 'How to use ChatGPT',
      content: 'Step-by-step guide to using ChatGPT for text generation.',
      url: 'https://help.openai.com/en/articles/6783452-chatgpt-user-guide',
    ),
    Tutorial(
      title: 'Getting started with DALL·E',
      content: 'Learn how to generate images with DALL·E.',
      url: 'https://openai.com/research/dall-e',
    ),
    // Add more tutorials...
  ];

  HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Tutorials')),
      body: ListView.builder(
        itemCount: tutorials.length,
        itemBuilder: (context, index) {
          final tutorial = tutorials[index];
          return ListTile(
            title: Text(tutorial.title),
            subtitle: Text(tutorial.content),
            trailing: const Icon(Icons.open_in_new),
            onTap: () async {
              final url = Uri.parse(tutorial.url);
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not open the link')),
                );
              }
            },
          );
        },
      ),
    );
  }
}