import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';
import '../services/mock_database_service.dart';
import '../services/user_data_storage.dart';
import '../theme/app_theme.dart';
import 'admin_dashboard_screen.dart';
import 'publisher_dashboard_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool loading = false;
  String? error;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signIn() async {
    setState(() { loading = true; error = null; });
    HapticFeedback.lightImpact();

    try {
      // Use mock database service for authentication
      final user = await MockDatabaseService.authenticateUser(
        emailController.text.trim(),
        passwordController.text.trim()
      );

      if (user != null) {
        // Authentication successful
        print('Sign-in successful for user: ${user['name']}');

        // Save user data including role
        await UserDataStorage.saveUser(user);

        // Provide haptic feedback on successful sign-in
        HapticFeedback.mediumImpact();

        setState(() { loading = false; });

        // Navigate based on user role
        _navigateBasedOnRole(user['role']);
      } else {
        // Authentication failed
        setState(() {
          error = 'Invalid email or password.';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Sign-in error: $e';
        loading = false;
      });
    }
  }

  void _navigateBasedOnRole(String role) {
    if (!mounted) return;

    switch (role) {
      case UserDataStorage.ROLE_ADMIN:
        Navigator.pushReplacementNamed(context, '/admin');
        break;
      case UserDataStorage.ROLE_PUBLISHER:
        Navigator.pushReplacementNamed(context, '/publisher');
        break;
      case UserDataStorage.ROLE_CUSTOMER:
      default:
        Navigator.pushReplacementNamed(context, '/home');
        break;
    }
  }

  void googleSignIn() async {
    setState(() { loading = true; error = null; });

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        // Provide haptic feedback on successful sign-in
        HapticFeedback.mediumImpact();

        // For Google Sign In, default to customer role
        final userData = {
          'name': googleUser.displayName ?? '',
          'email': googleUser.email,
          'provider': 'google',
          'role': UserDataStorage.ROLE_CUSTOMER, // Default role for Google sign-in
          'createdAt': DateTime.now().toIso8601String(),
        };

        await UserDataStorage.saveUser(userData);

        setState(() { loading = false; });

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        setState(() {
          loading = false;
          error = 'Google sign in cancelled.';
        });
      }
    } catch (e) {
      setState(() {
        loading = false;
        error = 'Google sign in failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF00E5FF)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Stack(
        children: [
          // Animated background
          Positioned.fill(
            child: CustomPaint(
              painter: SignInBackgroundPainter(
                animationValue: _animationController.value,
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Title
                    ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: AppTheme.primaryGradient,
                      ).createShader(bounds),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Text(
                      'Welcome back! Please enter your details',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Email
                    _buildTextField(
                      controller: emailController,
                      hintText: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 20),

                    // Password
                    _buildTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      icon: Icons.lock_outline,
                      obscureText: true,
                    ),

                    const SizedBox(height: 12),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Implement forgot password functionality
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: AppTheme.accentColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Error message
                    if (error != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.errorColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.errorColor.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: AppTheme.errorColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                error!,
                                style: const TextStyle(
                                  color: AppTheme.errorColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Sign in button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: loading ? null : signIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentColor,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                          shadowColor: AppTheme.accentColor.withOpacity(0.5),
                        ),
                        child: loading
                          ? const CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 3,
                            )
                          : const Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Divider
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(color: Colors.white30),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: Colors.white30),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Google sign in
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton.icon(
                        icon: Image.asset(
                          'assets/google_logo.png',
                          height: 24,
                        ),
                        label: const Text(
                          'Sign in with Google',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: loading ? null : googleSignIn,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Sign up option
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(context, '/signup'),
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              color: AppTheme.accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.3),
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.white.withOpacity(0.5),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}

class SignInBackgroundPainter extends CustomPainter {
  final double animationValue;

  SignInBackgroundPainter({required this.animationValue});

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

    // Draw circles
    _drawAnimatedCircles(canvas, size);

    // Draw grid pattern
    _drawGridPattern(canvas, size);
  }

  void _drawAnimatedCircles(Canvas canvas, Size size) {
    final circleCount = 3;
    final baseRadius = size.width * 0.3;

    for (int i = 0; i < circleCount; i++) {
      final offset = i * (3.14 * 2 / circleCount);
      final currentAngle = animationValue * 3.14 * 2 + offset;

      final x = size.width / 2 + (size.width * 0.3) *
                (i == 0 ? 0.8 : i == 1 ? -1.2 : 0.5) *
                (1 + 0.2 * (i == 0 ? 0.8 : i == 1 ? -0.2 : 0.5) *
                (1 + 0.1 * (i == 0 ? 0.8 : i == 1 ? -0.2 : 0.5)));

      final y = size.height * (i == 0 ? 0.2 : i == 1 ? 0.5 : 0.8);

      final radius = baseRadius * (0.4 + 0.2 * i);

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
      ..color = Colors.white.withOpacity(0.03)
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
