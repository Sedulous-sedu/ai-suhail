import 'package:flutter/material.dart';
import '../models/news_article.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsScreen extends StatelessWidget {
  final List<NewsArticle> news = [
    NewsArticle(
      title: 'OpenAI releases GPT-4 Turbo',
      summary: 'A faster, cheaper version of GPT-4 is now available.',
      url: 'https://openai.com/blog/gpt-4-turbo',
      date: DateTime(2024, 6, 1),
    ),
    NewsArticle(
      title: 'Stability AI launches new image model',
      summary: 'Stable Diffusion 3 brings higher quality and speed.',
      url: 'https://stability.ai/news/sd3',
      date: DateTime(2024, 5, 20),
    ),
    // Add more dummy news...
  ];

  NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI News & Updates')),
      body: ListView.builder(
        itemCount: news.length,
        itemBuilder: (context, index) {
          final article = news[index];
          return ListTile(
            title: Text(article.title),
            subtitle: Text(article.summary),
            trailing: const Icon(Icons.open_in_new),
            onTap: () async {
              final url = Uri.parse(article.url);
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