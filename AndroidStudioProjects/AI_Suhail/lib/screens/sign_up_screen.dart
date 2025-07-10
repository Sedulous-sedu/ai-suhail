import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

import '../services/mock_database_service.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  bool _isLoading = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  // Animation controllers
  late AnimationController _backgroundController;
  late AnimationController _formController;
  late AnimationController _buttonController;

  // Animations
  late Animation<double> _formOpacityAnimation;
  late Animation<Offset> _formSlideAnimation;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _formController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Setup animations
    _formOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _formController, curve: Curves.easeIn));

    _formSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _formController, curve: Curves.easeOut));

    _buttonScaleAnimation = Tween<double>(begin: 0.8, end: 1.0)
        .animate(CurvedAnimation(parent: _buttonController, curve: Curves.easeOutBack));

    // Start animations
    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _formController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    _buttonController.forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _formController.dispose();
    _buttonController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade800,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.shade700,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  bool _validatePassword(String password) {
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
    return true;
  }

  Future<void> _submitForm() async {
    setState(() {
      _nameError = null;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
      _isLoading = true;
    });

    try {
      // Basic validations
      if (_nameController.text.trim().isEmpty) {
        setState(() => _nameError = 'Name is required');
        return;
      }

      if (!EmailValidator.validate(_emailController.text.trim())) {
        setState(() => _emailError = 'Please enter a valid email address');
        return;
      }

      if (!_validatePassword(_passwordController.text)) {
        setState(() => _passwordError =
          'Password must be at least 8 characters with 1 number and 1 special character');
        return;
      }

      if (_passwordController.text != _confirmPasswordController.text) {
        setState(() => _confirmPasswordError = 'Passwords do not match');
        return;
      }

      // Check if email exists
      final emailExists = await MockDatabaseService.emailExists(_emailController.text);
      if (emailExists) {
        _showErrorSnackBar('User already exists with this email');
        return;
      }

      // Create user
      await MockDatabaseService.createUser(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );

      _showSuccessSnackBar('Account created successfully!');

      // Navigate to home screen
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      _showErrorSnackBar('Error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _navigateToSignIn() {
    HapticFeedback.lightImpact();
    Navigator.pop(context);
    Navigator.pushNamed(context, '/signin');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: Stack(
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return CustomPaint(
                painter: SignUpBackgroundPainter(
                  animationValue: _backgroundController.value,
                ),
                size: size,
              );
            },
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Header
                    ShaderMask(
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
                        'Create\nAccount',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Subtitle
                    Text(
                      'Please fill in the details to create your account',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Form with slide and fade animations
                    SlideTransition(
                      position: _formSlideAnimation,
                      child: FadeTransition(
                        opacity: _formOpacityAnimation,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Name field
                              PremiumTextField(
                                controller: _nameController,
                                label: 'Full Name',
                                errorText: _nameError,
                                prefixIcon: Icons.person_outline,
                              ),

                              const SizedBox(height: 20),

                              // Email field
                              PremiumTextField(
                                controller: _emailController,
                                label: 'Email Address',
                                errorText: _emailError,
                                prefixIcon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                              ),

                              const SizedBox(height: 20),

                              // Password field
                              PremiumTextField(
                                controller: _passwordController,
                                label: 'Password',
                                errorText: _passwordError,
                                prefixIcon: Icons.lock_outline,
                                obscureText: !_passwordVisible,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                    color: Colors.white60,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Confirm password field
                              PremiumTextField(
                                controller: _confirmPasswordController,
                                label: 'Confirm Password',
                                errorText: _confirmPasswordError,
                                prefixIcon: Icons.lock_outline,
                                obscureText: !_confirmPasswordVisible,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _confirmPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                    color: Colors.white60,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _confirmPasswordVisible = !_confirmPasswordVisible;
                                    });
                                  },
                                ),
                              ),

                              const SizedBox(height: 40),

                              // Sign up button with scale animation
                              ScaleTransition(
                                scale: _buttonScaleAnimation,
                                child: PremiumButton(
                                  onPressed: _isLoading ? null : _submitForm,
                                  isLoading: _isLoading,
                                  text: 'Create Account',
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF4776E6),
                                      Color(0xFF8E54E9),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 30),

                              // Sign in option
                              ScaleTransition(
                                scale: _buttonScaleAnimation,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Already have an account? ",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 15,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: _navigateToSignIn,
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
                                        child: const Text(
                                          'Sign In',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Premium styled text field with glass effect
class PremiumTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? errorText;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final bool obscureText;

  const PremiumTextField({
    super.key,
    required this.controller,
    required this.label,
    this.errorText,
    required this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = errorText != null
        ? Colors.red.shade300
        : Colors.white.withOpacity(0.2);

    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.red.shade300, width: 1.5),
    );

    final normalBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: borderColor, width: 1.5),
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: errorText != null
            ? [
                BoxShadow(
                  color: Colors.red.shade900.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Stack(
        children: [
          // Glass background
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 1.5),
                ),
              ),
            ),
          ),

          // TextField
          TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            keyboardType: keyboardType,
            obscureText: obscureText,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
              errorText: errorText,
              errorStyle: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
              prefixIcon: Icon(prefixIcon, color: Colors.white.withOpacity(0.7)),
              suffixIcon: suffixIcon,
              border: normalBorder,
              enabledBorder: normalBorder,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: const Color(0xFF4776E6).withOpacity(0.7),
                  width: 1.5,
                ),
              ),
              errorBorder: errorBorder,
              focusedErrorBorder: errorBorder,
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}

// Premium animated button
class PremiumButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String text;
  final Gradient gradient;

  const PremiumButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.text,
    required this.gradient,
  });

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton> with SingleTickerProviderStateMixin {
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
      onTapDown: widget.onPressed == null ? null : (_) {
        _controller.forward();
        setState(() => _isPressed = true);
        HapticFeedback.lightImpact();
      },
      onTapUp: widget.onPressed == null ? null : (_) {
        _controller.reverse();
        setState(() => _isPressed = false);
      },
      onTapCancel: widget.onPressed == null ? null : () {
        _controller.reverse();
        setState(() => _isPressed = false);
      },
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: widget.gradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: widget.onPressed == null || _isPressed
                    ? []
                    : [
                        BoxShadow(
                          color: const Color(0xFF4776E6).withOpacity(0.5),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
              ),
              child: Center(
                child: widget.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        widget.text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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

// Background painter for sign-up screen
class SignUpBackgroundPainter extends CustomPainter {
  final double animationValue;

  SignUpBackgroundPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    // Create two-tone background gradient (purple to deep blue)
    final backgroundPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0xFF2E1D66), // Deep purple
          Color(0xFF0C0B1D), // Nearly black
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Draw subtle grid pattern
    _drawGridPattern(canvas, size);

    // Draw floating particles
    _drawParticles(canvas, size);

    // Draw blurred gradient circles
    _drawGradientCircles(canvas, size);
  }

  void _drawGridPattern(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    const spacing = 40.0;
    final countX = (size.width / spacing).ceil() + 1;
    final countY = (size.height / spacing).ceil() + 1;

    // Draw horizontal lines
    for (var i = 0; i < countY; i++) {
      final y = i * spacing;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw vertical lines
    for (var i = 0; i < countX; i++) {
      final x = i * spacing;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
  }

  void _drawParticles(Canvas canvas, Size size) {
    const particleCount = 30;
    final random = math.Random(42);

    for (int i = 0; i < particleCount; i++) {
      final initialX = random.nextDouble() * size.width;
      final initialY = random.nextDouble() * size.height;

      // Create movement effect
      final speed = 0.5 + random.nextDouble() * 1.5;
      final offsetX = math.sin(animationValue * 2 * math.pi * speed + i) * 20;
      final offsetY = math.cos(animationValue * 2 * math.pi * speed + i) * 20;

      final x = (initialX + offsetX) % size.width;
      final y = (initialY + offsetY) % size.height;

      // Particle properties
      final opacity = 0.3 + 0.5 * random.nextDouble();
      final particleSize = 1 + random.nextDouble() * 3;

      // Choose colors from purple-blue spectrum
      final colorIndex = random.nextInt(3);
      final colors = [
        const Color(0xFF4776E6), // Blue
        const Color(0xFF8E54E9), // Purple
        Colors.white,            // White
      ];

      final paint = Paint()
        ..color = colors[colorIndex].withOpacity(opacity)
        ..style = PaintingStyle.fill;

      // Add glow effect
      final glowPaint = Paint()
        ..color = colors[colorIndex].withOpacity(opacity * 0.4)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawCircle(Offset(x, y), particleSize * 2, glowPaint);
      canvas.drawCircle(Offset(x, y), particleSize, paint);
    }
  }

  void _drawGradientCircles(Canvas canvas, Size size) {
    // First large gradient circle in top right
    final circle1CenterX = size.width * 1.0;
    final circle1CenterY = size.height * -0.2;
    final circle1Radius = size.width * 0.6;

    final circle1Paint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF4776E6).withOpacity(0.3),
          const Color(0xFF4776E6).withOpacity(0.1),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(
        center: Offset(circle1CenterX, circle1CenterY),
        radius: circle1Radius,
      ));

    canvas.drawCircle(
      Offset(circle1CenterX, circle1CenterY),
      circle1Radius,
      circle1Paint,
    );

    // Second large gradient circle in bottom left
    final circle2CenterX = size.width * -0.2;
    final circle2CenterY = size.height * 1.0;
    final circle2Radius = size.width * 0.7;

    final circle2Paint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF8E54E9).withOpacity(0.3),
          const Color(0xFF8E54E9).withOpacity(0.1),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(
        center: Offset(circle2CenterX, circle2CenterY),
        radius: circle2Radius,
      ));

    canvas.drawCircle(
      Offset(circle2CenterX, circle2CenterY),
      circle2Radius,
      circle2Paint,
    );

    // Moving highlight circle
    final highlightX = size.width * (0.2 + 0.6 * math.sin(animationValue * math.pi));
    final highlightY = size.height * (0.1 + 0.3 * math.cos(animationValue * math.pi * 0.7));
    final highlightRadius = size.width * 0.3;

    final highlightPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(0.07),
          Colors.transparent,
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(
        center: Offset(highlightX, highlightY),
        radius: highlightRadius,
      ));

    canvas.drawCircle(
      Offset(highlightX, highlightY),
      highlightRadius,
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
