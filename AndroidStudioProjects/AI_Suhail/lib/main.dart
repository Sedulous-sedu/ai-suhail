import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'tool_detail_screen.dart';
import 'models/tool.dart';
import 'models/category.dart';
import 'screens/news_screen.dart';
import 'screens/help_screen.dart';
import 'screens/auth_welcome_screen.dart';
import 'screens/bard_screen.dart';
import 'screens/claude_screen.dart';
import 'screens/dalle_screen.dart';
import 'screens/midjourney_screen.dart';
import 'screens/stable_diffusion_screen.dart';
import 'screens/veo3_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/publisher_dashboard_screen.dart';
import 'services/db_test.dart';
import 'theme/app_theme.dart';
import 'providers/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style for a more immersive experience
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.cardBackground,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  await dotenv.load(fileName: '.env');
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const AIToolboxApp(),
    ),
  );
}

class AIToolboxApp extends StatelessWidget {
  const AIToolboxApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'AI Toolbox',
      theme: themeProvider.isDarkMode ? AppTheme.darkTheme() : AppTheme.lightTheme(),
      debugShowCheckedModeBanner: false,
      home: const AuthWelcomeScreen(),
      routes: {
        '/home': (_) => const HomeScreen(),
        '/signin': (_) => const SignInScreen(),
        '/signup': (_) => const SignUpScreen(),
        '/bard': (_) => const BardScreen(),
        '/claude': (_) => const ClaudeScreen(),
        '/dalle': (_) => const DalleScreen(),
        '/midjourney': (_) => const MidjourneyScreen(),
        '/stable_diffusion': (_) => const StableDiffusionScreen(),
        '/veo3': (_) => const Veo3Screen(),
        '/dbtest': (_) => DatabaseTest(),
        '/profile': (_) => const ProfileScreen(),
        '/admin': (_) => const AdminDashboardScreen(),
        '/publisher': (_) => const PublisherDashboardScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Category> categories = const [
    Category(name: 'Text Generation', icon: '💬'),
    Category(name: 'Image & Video Generation', icon: '🖼️'),
    Category(name: 'Translation & Speech', icon: '🌐'),
    Category(name: 'Developer Tools', icon: '💻'),
  ];

  final List<Tool> allTools = const [
    // Text Generation
    Tool(
      name: 'ChatGPT',
      description: 'Conversational AI by OpenAI.',
      category: 'Text Generation',
      icon: '💬',
      link: 'https://chat.openai.com/',
    ),
    Tool(
      name: 'Claude',
      description: 'AI assistant by Anthropic.',
      category: 'Text Generation',
      icon: '🤖',
      link: 'https://www.anthropic.com/claude',
    ),
    Tool(
      name: 'Bard',
      description: 'Conversational AI by Google.',
      category: 'Text Generation',
      icon: '📝',
      link: 'https://bard.google.com/',
    ),

    // Image & Video Generation
    Tool(
      name: 'DALL·E',
      description: 'Image generation by OpenAI.',
      category: 'Image & Video Generation',
      icon: '🖼️',
      link: 'https://labs.openai.com/',
    ),
    Tool(
      name: 'Midjourney',
      description: 'AI-powered image generation.',
      category: 'Image & Video Generation',
      icon: '🎨',
      link: 'https://www.midjourney.com/',
    ),
    Tool(
      name: 'Stable Diffusion',
      description: 'Open-source image generation.',
      category: 'Image & Video Generation',
      icon: '🖌️',
      link: 'https://stability.ai/',
    ),
    Tool(
      name: 'RunwayML',
      description: 'AI video and image tools.',
      category: 'Image & Video Generation',
      icon: '🎬',
      link: 'https://runwayml.com/',
    ),
    Tool(
      name: 'Veo3',
      description: 'Advanced video generation by Google DeepMind.',
      category: 'Image & Video Generation',
      icon: '📹',
      link: 'https://deepmind.google/technologies/veo/',
    ),

    // Translation & Speech
    Tool(
      name: 'Google Translate API',
      description: 'Translation and speech recognition.',
      category: 'Translation & Speech',
      icon: '🌐',
      link: 'https://cloud.google.com/translate',
    ),
    Tool(
      name: 'Microsoft Azure Speech to Text',
      description: 'Speech recognition by Microsoft.',
      category: 'Translation & Speech',
      icon: '🗣️',
      link: 'https://azure.microsoft.com/en-us/products/ai-services/speech-to-text/',
    ),
    Tool(
      name: 'Whisper',
      description: 'OpenAI\'s speech recognition model.',
      category: 'Translation & Speech',
      icon: '🔊',
      link: 'https://openai.com/research/whisper',
    ),

    // Developer Tools & Coding Assistance
    Tool(
      name: 'GitHub Copilot',
      description: 'AI coding assistant.',
      category: 'Developer Tools',
      icon: '💻',
      link: 'https://github.com/features/copilot',
    ),
    Tool(
      name: 'Tabnine',
      description: 'AI code completion assistant.',
      category: 'Developer Tools',
      icon: '🤖',
      link: 'https://www.tabnine.com/',
    ),
    Tool(
      name: 'CodeWhisperer',
      description: 'AI coding assistant by AWS.',
      category: 'Developer Tools',
      icon: '🧑‍💻',
      link: 'https://aws.amazon.com/codewhisperer/',
    ),
    Tool(
      name: 'Lovable',
      description: 'AI-powered code assistant.',
      category: 'Developer Tools',
      icon: '❤️',
      link: 'https://lovable.so/',
    ),
    Tool(
      name: 'Cursor',
      description: 'AI coding assistant and editor.',
      category: 'Developer Tools',
      icon: '🖱️',
      link: 'https://www.cursor.so/',
    ),
  ];

  String searchQuery = '';

  void _navigateToProfile(BuildContext context) {
    try {
      Navigator.pushNamed(context, '/profile');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredTools = allTools.where((tool) {
      final q = searchQuery.toLowerCase();
      return tool.name.toLowerCase().contains(q) || tool.category.toLowerCase().contains(q);
    }).toList();

    final featuredTools = allTools.take(3).toList();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('AI Toolbox'),
          actions: [
            // Add profile icon with tap functionality
            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () => _navigateToProfile(context),
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                child: const Text(
                  'AI Toolbox',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.newspaper),
                title: const Text('News & Updates'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => NewsScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help & Tutorials'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => HelpScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToProfile(context);
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for a tool...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (value) => setState(() => searchQuery = value),
                ),
              ),
              SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: featuredTools.length,
                  itemBuilder: (context, index) {
                    final tool = featuredTools[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ToolDetailScreen(tool: tool)),
                      ),
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          width: 220,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tool.icon, style: const TextStyle(fontSize: 32)),
                              const SizedBox(height: 8),
                              Text(
                                tool.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tool.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Categorized Tools
              ...categories.expand((category) {
                final toolsInCat = filteredTools.where((t) => t.category == category.name).toList();
                if (toolsInCat.isEmpty) return <Widget>[];
                return [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      '${category.icon} ${category.name}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...toolsInCat.map((tool) => Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: ListTile(
                          leading: Text(tool.icon, style: const TextStyle(fontSize: 24)),
                          title: Text(tool.name),
                          subtitle: Text(tool.description),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ToolDetailScreen(tool: tool)),
                          ),
                        ),
                      )).toList(),
                ];
              }),
            ],
          ),
        ),
      ),
    );
  }
}
