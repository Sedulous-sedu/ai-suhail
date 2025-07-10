import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

import '../theme/app_theme.dart';
import '../services/user_data_storage.dart';

class AuthWelcomeScreen extends StatefulWidget {
  const AuthWelcomeScreen({super.key});

  @override
  State<AuthWelcomeScreen> createState() => _AuthWelcomeScreenState();
}

class _AuthWelcomeScreenState extends State<AuthWelcomeScreen> with TickerProviderStateMixin {
  bool isLoading = false;
  String? error;

  // Animation controllers
  late AnimationController _backgroundController;
  late AnimationController _cardsController;
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _buttonController;

  // Animations
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers with different durations
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _cardsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Setup animations
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0)
      .animate(CurvedAnimation(parent: _logoController, curve: Curves.elasticOut));

    _logoRotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi)
      .animate(CurvedAnimation(parent: _logoController, curve: Curves.easeInOut));

    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
      .animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    _textSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
      .animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _buttonScaleAnimation = Tween<double>(begin: 0.8, end: 1.0)
      .animate(CurvedAnimation(parent: _buttonController, curve: Curves.easeOutBack));

    // Start animations in sequence
    _startAnimationsSequence();
  }

  void _startAnimationsSequence() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();

    await Future.delayed(const Duration(milliseconds: 400));
    _cardsController.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    _buttonController.forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _logoController.dispose();
    _textController.dispose();
    _cardsController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  Future<void> googleSignIn() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        // Provide haptic feedback on successful sign-in
        HapticFeedback.mediumImpact();

        await UserDataStorage.saveUser({
          'name': googleUser.displayName ?? '',
          'email': googleUser.email,
          'provider': 'google',
          'createdAt': DateTime.now().toIso8601String(),
        });

        setState(() {
          isLoading = false;
        });

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        setState(() {
          isLoading = false;
          error = 'Google sign in cancelled.';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        error = 'Failed to sign in with Google: $e';
      });
    }
  }

  Future<void> emailSignIn() async {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/signin');
  }

  Future<void> emailSignUp() async {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Animated dynamic background
            AnimatedBackground(controller: _backgroundController),

            // Content with animations
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: SizedBox(
                  height: size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),

                        // Animated logo
                        Center(
                          child: AnimatedBuilder(
                            animation: _logoController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _logoScaleAnimation.value,
                                child: Transform.rotate(
                                  angle: _logoRotationAnimation.value,
                                  child: child,
                                ),
                              );
                            },
                            child: LogoContainer(),
                          ),
                        ),

                        const SizedBox(height: 50),

                        // Welcome text with slide and fade animations
                        SlideTransition(
                          position: _textSlideAnimation,
                          child: FadeTransition(
                            opacity: _textOpacityAnimation,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Welcome header
                                const WelcomeHeader(),

                                const SizedBox(height: 16),

                                // Description text
                                const Text(
                                  'Discover, explore and use powerful AI tools for text, image, video generation, and more - all in one app.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Feature cards with staggered animation
                        const SizedBox(height: 40),
                        AnimatedFeatureCards(controller: _cardsController),

                        const Spacer(),

                        // Sign in buttons with scale animation
                        ScaleTransition(
                          scale: _buttonScaleAnimation,
                          child: Column(
                            children: [
                              // Google sign in button
                              PremiumAuthButton(
                                icon: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                    'assets/google_logo.png',
                                    height: 20,
                                  ),
                                ),
                                text: 'Continue with Google',
                                onTap: googleSignIn,
                                isLoading: isLoading,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white,
                                    Colors.white.withOpacity(0.85),
                                  ],
                                ),
                                textColor: Colors.black87,
                              ),

                              const SizedBox(height: 16),

                              // Email sign in button
                              PremiumAuthButton(
                                icon: const Icon(Icons.email_outlined, color: Colors.white, size: 24),
                                text: 'Sign in with Email',
                                onTap: emailSignIn,
                                isLoading: false,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFF4776E6),
                                    const Color(0xFF8E54E9),
                                  ],
                                ),
                                textColor: Colors.white,
                              ),

                              const SizedBox(height: 24),

                              // Sign up option
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Don't have an account? ",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 15,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: emailSignUp,
                                    child: const Text(
                                      'Sign up',
                                      style: TextStyle(
                                        color: Color(0xFF8E54E9),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Error message
                        if (error != null)
                          Container(
                            margin: const EdgeInsets.only(top: 16),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red.withOpacity(0.3), width: 1),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    error!,
                                    style: const TextStyle(color: Colors.red, fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Modern animated background with particles and gradients
class AnimatedBackground extends StatelessWidget {
  final AnimationController controller;

  const AnimatedBackground({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: DynamicBackgroundPainter(
            animationValue: controller.value,
          ),
          size: MediaQuery.of(context).size,
        );
      },
    );
  }
}

// Logo with glass effect and gradient outline
class LogoContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.black.withOpacity(0.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4776E6).withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Center(
            child: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4776E6),
                  Color(0xFF8E54E9),
                ],
              ).createShader(bounds),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 60,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Animated welcome header with gradient text
class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF4776E6),
          Color(0xFF8E54E9),
        ],
      ).createShader(bounds),
      child: const Text(
        'Welcome to AI_Suhail',
        style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          height: 1.2,
        ),
      ),
    );
  }
}

// Animated feature cards with staggered animations
class AnimatedFeatureCards extends StatelessWidget {
  final AnimationController controller;

  const AnimatedFeatureCards({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // Create staggered animations for each card
    final firstCardAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
          parent: controller,
          curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        ));

    final secondCardAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
          parent: controller,
          curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
        ));

    final thirdCardAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
          parent: controller,
          curve: const Interval(0.5, 0.9, curve: Curves.easeOut),
        ));

    return SizedBox(
      height: 100,
      child: Row(
        children: [
          Expanded(
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) => Transform.scale(
                scale: firstCardAnimation.value,
                child: Opacity(
                  opacity: firstCardAnimation.value,
                  child: child,
                ),
              ),
              child: _buildFeatureCard(
                icon: Icons.text_fields,
                title: 'Text AI',
                gradient: const LinearGradient(
                  colors: [Color(0xFF00C6FB), Color(0xFF005BEA)],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) => Transform.scale(
                scale: secondCardAnimation.value,
                child: Opacity(
                  opacity: secondCardAnimation.value,
                  child: child,
                ),
              ),
              child: _buildFeatureCard(
                icon: Icons.image,
                title: 'Image Gen',
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFA62E), Color(0xFFEA4D2C)],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) => Transform.scale(
                scale: thirdCardAnimation.value,
                child: Opacity(
                  opacity: thirdCardAnimation.value,
                  child: child,
                ),
              ),
              child: _buildFeatureCard(
                icon: Icons.code,
                title: 'Dev Tools',
                gradient: const LinearGradient(
                  colors: [Color(0xFF16A085), Color(0xFFF4D03F)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required Gradient gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) => gradient.createShader(bounds),
                  child: Icon(
                    icon,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// New premium styled button with animations
class PremiumAuthButton extends StatefulWidget {
  final Widget icon;
  final String text;
  final VoidCallback onTap;
  final bool isLoading;
  final Gradient gradient;
  final Color textColor;

  const PremiumAuthButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    required this.isLoading,
    required this.gradient,
    required this.textColor,
  });

  @override
  State<PremiumAuthButton> createState() => _PremiumAuthButtonState();
}

class _PremiumAuthButtonState extends State<PremiumAuthButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();
        setState(() => _isPressed = true);
        HapticFeedback.lightImpact();
      },
      onTapUp: (_) {
        _controller.reverse();
        setState(() => _isPressed = false);
      },
      onTapCancel: () {
        _controller.reverse();
        setState(() => _isPressed = false);
      },
      onTap: widget.isLoading ? null : widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: widget.gradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: _isPressed
                    ? []
                    : [
                        BoxShadow(
                          color: widget.gradient.colors.first.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.isLoading
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(widget.textColor),
                                strokeWidth: 2.5,
                              ),
                            )
                          : widget.icon,
                      const SizedBox(width: 12),
                      Text(
                        widget.text,
                        style: TextStyle(
                          color: widget.textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DynamicBackgroundPainter extends CustomPainter {
  final double animationValue;

  DynamicBackgroundPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    // Deep blue-black gradient background
    final backgroundPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF0F0C29),
          Color(0xFF302B63),
          Color(0xFF24243E),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Draw animated background grid (more subtle and premium)
    _drawPremiumGrid(canvas, size);

    // Draw floating glass panels
    _drawGlassPanels(canvas, size);

    // Draw animated particles
    _drawPremiumParticles(canvas, size);

    // Draw gradient overlays
    _drawGradientOverlays(canvas, size);
  }

  void _drawPremiumGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    const spacing = 40.0;
    final countX = (size.width / spacing).ceil() + 1;
    final countY = (size.height / spacing).ceil() + 1;

    // Create a slight wave effect for the grid
    final baseOffsetY = size.height * 0.05;
    final waveFrequency = 3.0; // Controls how many waves fit in the screen

    // Horizontal lines with wave effect
    for (var i = 0; i < countY; i++) {
      final path = Path();
      for (var x = 0.0; x < size.width; x += 5) {
        final normalizedX = x / size.width;
        final waveOffset = math.sin(normalizedX * math.pi * waveFrequency + animationValue * math.pi * 2) * baseOffsetY;

        final y = i * spacing + waveOffset;

        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, gridPaint);
    }

    // Vertical lines (straight)
    for (var i = 0; i < countX; i++) {
      final x = i * spacing;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
  }

  void _drawGlassPanels(Canvas canvas, Size size) {
    // First glass panel (top left)
    final panel1Width = size.width * 0.6;
    final panel1Height = size.height * 0.3;
    final panel1X = -panel1Width * 0.3 + (math.sin(animationValue * math.pi) * 20);
    final panel1Y = -panel1Height * 0.3 + (math.cos(animationValue * math.pi) * 15);

    final panel1Rect = Rect.fromLTWH(panel1X, panel1Y, panel1Width, panel1Height);
    final panel1Paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.1),
          Colors.white.withOpacity(0.05),
        ],
      ).createShader(panel1Rect);

    final panel1Path = Path()
      ..addRRect(RRect.fromRectAndRadius(panel1Rect, const Radius.circular(20)));
    canvas.drawPath(panel1Path, panel1Paint);

    // Second glass panel (bottom right)
    final panel2Width = size.width * 0.7;
    final panel2Height = size.height * 0.4;
    final panel2X = size.width - panel2Width * 0.7 + (math.cos(animationValue * math.pi) * 20);
    final panel2Y = size.height - panel2Height * 0.7 + (math.sin(animationValue * math.pi) * 15);

    final panel2Rect = Rect.fromLTWH(panel2X, panel2Y, panel2Width, panel2Height);
    final panel2Paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.06),
          Colors.white.withOpacity(0.02),
        ],
      ).createShader(panel2Rect);

    final panel2Path = Path()
      ..addRRect(RRect.fromRectAndRadius(panel2Rect, const Radius.circular(20)));
    canvas.drawPath(panel2Path, panel2Paint);
  }

  void _drawPremiumParticles(Canvas canvas, Size size) {
    const particleCount = 50;
    final random = math.Random(42); // Fixed seed for consistent pattern

    for (int i = 0; i < particleCount; i++) {
      final initialX = random.nextDouble() * size.width;
      final initialY = random.nextDouble() * size.height;

      // Movement based on animation value with varying speeds
      final speed = 0.5 + random.nextDouble() * 1.5;
      final offsetX = math.sin(animationValue * 2 * math.pi * speed + i) * 15;
      final offsetY = math.cos(animationValue * 2 * math.pi * speed + i) * 15;

      final x = (initialX + offsetX) % size.width;
      final y = (initialY + offsetY) % size.height;

      // Particle size and opacity variations
      final brightness = 0.3 + 0.7 * random.nextDouble();
      final particleSize = 1 + random.nextDouble() * 3;

      // Color variations
      final hue = (220 + random.nextDouble() * 60) % 360; // Blue to purple range
      final color = HSLColor.fromAHSL(
        brightness * 0.6,
        hue,
        0.7,
        0.6,
      ).toColor();

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      // Draw glowing particle
      final glowPaint = Paint()
        ..color = color.withOpacity(0.3)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawCircle(Offset(x, y), particleSize * 2, glowPaint);
      canvas.drawCircle(Offset(x, y), particleSize, paint);
    }
  }

  void _drawGradientOverlays(Canvas canvas, Size size) {
    // Top gradient overlay
    final topGradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.center,
        colors: [
          const Color(0xFF4776E6).withOpacity(0.2),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.6));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height * 0.6), topGradientPaint);

    // Bottom gradient overlay
    final bottomGradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.center,
        colors: [
          const Color(0xFF8E54E9).withOpacity(0.15),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, size.height * 0.4, size.width, size.height * 0.6));

    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.4, size.width, size.height * 0.6), bottomGradientPaint);

    // Moving light source effect
    final lightX = size.width * (0.5 + 0.3 * math.sin(animationValue * math.pi));
    final lightY = size.height * (0.3 + 0.2 * math.cos(animationValue * math.pi * 0.7));

    final lightRadius = size.width * 0.6;
    final lightPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.0, 0.0),
        radius: 1.0,
        colors: [
          Colors.white.withOpacity(0.07),
          Colors.transparent,
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(
        center: Offset(lightX, lightY),
        radius: lightRadius,
      ));

    canvas.drawCircle(
      Offset(lightX, lightY),
      lightRadius,
      lightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
