import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'dart:ui';
import '../theme/app_theme.dart';
import '../models/tool.dart';
import '../models/category.dart';
import '../tool_detail_screen.dart';
import 'profile_screen.dart';
import '../widgets/profile_avatar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
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

  late final TabController _tabController;
  late final AnimationController _animationController;
  String searchQuery = '';
  int _currentIndex = 0;
  bool _isSearchVisible = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    // Add haptic feedback when tab changes for a more immersive experience
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        HapticFeedback.lightImpact();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToProfile(BuildContext context) {
    try {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const ProfileScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutQuart;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening profile: $e')),
      );
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (!_isSearchVisible) {
        _searchController.clear();
        searchQuery = '';
      }
    });

    if (_isSearchVisible) {
      HapticFeedback.mediumImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredTools = allTools.where((tool) {
      if (searchQuery.isEmpty) {
        return _currentIndex == 0 || tool.category == categories[_currentIndex - 1].name;
      }
      final q = searchQuery.toLowerCase();
      return (tool.name.toLowerCase().contains(q) ||
              tool.description.toLowerCase().contains(q) ||
              tool.category.toLowerCase().contains(q)) &&
              (_currentIndex == 0 || tool.category == categories[_currentIndex - 1].name);
    }).toList();

    // Tools that are frequently used or recommended
    final featuredTools = allTools.take(5).toList();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            // Animated background
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: BackgroundPainter(
                    animationValue: _animationController.value,
                  ),
                  child: Container(),
                );
              },
            ),

            // Main content
            SafeArea(
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 180.0,
                      floating: false,
                      pinned: true,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: false,
                        titlePadding: const EdgeInsets.only(left: 20, bottom: 16, right: 20),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'AI Toolbox',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: AppTheme.textPrimary,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withAlpha(128),
                                    offset: const Offset(1, 1),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: _isSearchVisible
                                ? IconButton(
                                    icon: const Icon(Icons.close, color: AppTheme.accentColor),
                                    onPressed: _toggleSearch,
                                  )
                                : IconButton(
                                    icon: const Icon(Icons.search, color: AppTheme.accentColor),
                                    onPressed: _toggleSearch,
                                  ),
                            ),
                          ],
                        ),
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Gradient overlay
                            Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    AppTheme.primaryDark,
                                  ],
                                ),
                              ),
                            ),

                            // Welcome message with glowing effect
                            Positioned(
                              top: 40,
                              left: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ShaderMask(
                                    blendMode: BlendMode.srcIn,
                                    shaderCallback: (bounds) => const LinearGradient(
                                      colors: AppTheme.primaryGradient,
                                    ).createShader(bounds),
                                    child: const Text(
                                      'Welcome back',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Discover the power of AI',
                                    style: TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: ProfileAvatar(
                            size: 40,
                            showBorder: true,
                          ),
                        ),
                      ],
                    ),

                    // Search bar
                    SliverToBoxAdapter(
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: _isSearchVisible
                            ? Padding(
                                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppTheme.cardBackground,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(51),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: TextField(
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      hintText: 'Search AI tools...',
                                      prefixIcon: const Icon(Icons.search, color: AppTheme.accentColor),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 16,
                                      ),
                                    ),
                                    style: const TextStyle(color: AppTheme.textPrimary),
                                    onChanged: (value) {
                                      setState(() {
                                        searchQuery = value;
                                      });
                                    },
                                    autofocus: true,
                                  ),
                                ),
                              )
                            : const SizedBox(height: 0),
                      ),
                    ),

                    // Custom category tabs
                    SliverToBoxAdapter(
                      child: Container(
                        height: 58,
                        margin: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            _buildCategoryTab('All', 0, Icons.apps),
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: categories.length,
                                itemBuilder: (context, index) {
                                  final category = categories[index];
                                  return _buildCategoryTab(
                                    category.name,
                                    index + 1,
                                    _getCategoryIcon(category.name),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Featured tools section
                    if (_currentIndex == 0 && searchQuery.isEmpty)
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
                              child: Text(
                                '✨ Featured Tools',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: featuredTools.length,
                                itemBuilder: (context, index) {
                                  final tool = featuredTools[index];
                                  return _buildFeaturedToolCard(tool, index);
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
                              child: Text(
                                '🛠️ All Tools',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ];
                },
                body: filteredTools.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: AppTheme.textSecondary.withAlpha(128),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No tools found',
                              style: TextStyle(
                                fontSize: 18,
                                color: AppTheme.textSecondary.withAlpha(204),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try changing your search or filter',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary.withAlpha(153),
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: filteredTools.length,
                        itemBuilder: (context, index) {
                          final tool = filteredTools[index];
                          return _buildToolCard(tool);
                        },
                      ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: 80,
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(51),
                offset: const Offset(0, -1),
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, Icons.home, 'Home', 0),
              _buildNavItem(Icons.explore_outlined, Icons.explore, 'Explore', 1),
              _buildNavItem(Icons.lightbulb_outline, Icons.lightbulb, 'Learn', 2),
              _buildNavItem(Icons.person_outline, Icons.person, 'Profile', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTab(String label, int index, IconData icon) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
        HapticFeedback.lightImpact();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.accentColor
              : AppTheme.cardBackground.withAlpha(178),
          borderRadius: BorderRadius.circular(30),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.accentColor.withAlpha(102),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.black : AppTheme.textSecondary,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, IconData selectedIcon, String label, int index) {
    final isSelected = index == 0; // Currently only Home is implemented

    return InkWell(
      onTap: () {
        if (index == 3) {
          _navigateToProfile(context);
        } else if (index != 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$label section coming soon!'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              action: SnackBarAction(
                label: 'OK',
                textColor: AppTheme.accentColor,
                onPressed: () {},
              ),
            ),
          );
        }
        HapticFeedback.lightImpact();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? selectedIcon : icon,
            color: isSelected ? AppTheme.accentColor : AppTheme.textSecondary,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppTheme.accentColor : AppTheme.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedToolCard(Tool tool, int index) {
    return Hero(
      tag: 'featured-${tool.name}',
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => ToolDetailScreen(tool: tool),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = 0.0;
                  const end = 1.0;
                  const curve = Curves.easeInOut;

                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                  return FadeTransition(opacity: animation.drive(tween), child: child);
                },
                transitionDuration: const Duration(milliseconds: 500),
              ),
            ),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    HSLColor.fromColor(AppTheme.accentColor)
                        .withLightness(0.25 + (index * 0.05))
                        .withSaturation(0.8)
                        .toColor(),
                    HSLColor.fromColor(AppTheme.secondaryAccent)
                        .withLightness(0.2 + (index * 0.05))
                        .withSaturation(0.9)
                        .toColor(),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: HSLColor.fromColor(AppTheme.accentColor)
                        .withLightness(0.4)
                        .withSaturation(0.8)
                        .toColor()
                        .withAlpha(102),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Background decoration
                  Positioned(
                    right: -20,
                    bottom: -20,
                    child: Opacity(
                      opacity: 0.2,
                      child: Text(
                        tool.icon,
                        style: const TextStyle(fontSize: 120),
                      ),
                    ),
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(51),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                tool.icon,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tool.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  tool.category,
                                  style: TextStyle(
                                    color: Colors.white.withAlpha(204),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          tool.description,
                          style: TextStyle(
                            color: Colors.white.withAlpha(230),
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(51),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Row(
                                children: [
                                  Text(
                                    'Try it',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToolCard(Tool tool) {
    return Hero(
      tag: 'tool-${tool.name}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => ToolDetailScreen(tool: tool),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = 0.0;
                const end = 1.0;
                const curve = Curves.easeInOut;

                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                return FadeTransition(opacity: animation.drive(tween), child: child);
              },
              transitionDuration: const Duration(milliseconds: 500),
            ),
          ),
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Card background
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primaryLight.withAlpha(230),
                      AppTheme.cardBackground.withAlpha(230),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(51),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),

              // Card content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon circle
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceBackground.withAlpha(153),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        tool.icon,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Tool name
                    Text(
                      tool.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppTheme.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Tool description
                    Text(
                      tool.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),

                    // Button
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppTheme.accentColor.withAlpha(38),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Open',
                            style: TextStyle(
                              color: AppTheme.accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward,
                            color: AppTheme.accentColor,
                            size: 12,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Text Generation':
        return Icons.chat_bubble_outline;
      case 'Image & Video Generation':
        return Icons.image;
      case 'Translation & Speech':
        return Icons.translate;
      case 'Developer Tools':
        return Icons.code;
      default:
        return Icons.category;
    }
  }
}

// Custom background painter for animated effect
class BackgroundPainter extends CustomPainter {
  final double animationValue;

  BackgroundPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.primaryDark,
          const Color(0xFF0F1229),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Draw animated circles
    _drawAnimatedCircles(canvas, size);

    // Draw grid pattern
    _drawGridPattern(canvas, size);
  }

  void _drawAnimatedCircles(Canvas canvas, Size size) {
    final circleCount = 3;
    final baseRadius = math.min(size.width, size.height) * 0.3;

    for (int i = 0; i < circleCount; i++) {
      final offset = i * (math.pi * 2 / circleCount);
      final currentAngle = animationValue * math.pi * 2 + offset;

      final x = size.width / 2 + math.cos(currentAngle) * (baseRadius / 2);
      final y = size.height / 3 + math.sin(currentAngle) * (baseRadius / 3);
      final radius = baseRadius * (0.4 + (math.sin(currentAngle * 2) + 1) / 4);

      final circlePaint = Paint()
        ..shader = RadialGradient(
          colors: [
            AppTheme.accentColor.withOpacity(0.2),
            AppTheme.accentColorDark.withOpacity(0.05),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: Offset(x, y), radius: radius));

      canvas.drawCircle(Offset(x, y), radius, circlePaint);
    }
  }

  void _drawGridPattern(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withAlpha(8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    const spacing = 40.0;
    final countX = (size.width / spacing).ceil();
    final countY = (size.height / spacing).ceil();

    // Horizontal lines
    for (var i = 0; i <= countY; i++) {
      final y = i * spacing;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Vertical lines
    for (var i = 0; i <= countX; i++) {
      final x = i * spacing;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
