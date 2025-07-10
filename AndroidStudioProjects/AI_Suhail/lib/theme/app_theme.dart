import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';

class AppTheme {
  // Primary colors - Dark Mode
  static const Color primaryDark = Color(0xFF0A0E21);
  static const Color primaryLight = Color(0xFF1F1F30);
  static const Color accentColor = Color(0xFF00E5FF);
  static const Color accentColorDark = Color(0xFF00AAFF);
  static const Color secondaryAccent = Color(0xFF6C63FF);

  // Primary colors - Light Mode
  static const Color primaryLightMode = Color(0xFFFAFAFC);
  static const Color secondaryLightMode = Color(0xFFF1F3F9);
  static const Color accentLightMode = Color(0xFF2D7FF9);
  static const Color secondaryAccentLightMode = Color(0xFF7E6CF6);

  // Text colors - Dark Mode
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0C0);
  static const Color textDisabled = Color(0xFF636380);

  // Text colors - Light Mode
  static const Color textPrimaryLight = Color(0xFF202030);
  static const Color textSecondaryLight = Color(0xFF5F6277);
  static const Color textDisabledLight = Color(0xFFADAFC0);

  // UI colors - Dark Mode
  static const Color cardBackground = Color(0xFF15162D);
  static const Color surfaceBackground = Color(0xFF0D0E1F);

  // Aliases for backwards compatibility (used in some screens)
  static const Color cardBackgroundDark = cardBackground;
  static const Color textColorLight = textSecondaryLight;
  static const Color dividerColor = Color(0xFF282840);
  static const Color errorColor = Color(0xFFFF5252);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFFB74D);

  // UI colors - Light Mode
  static const Color cardBackgroundLight = Color(0xFFFFFFFF);
  static const Color surfaceBackgroundLight = Color(0xFFF5F7FB);
  static const Color dividerColorLight = Color(0xFFEAECF2);
  static const Color errorColorLight = Color(0xFFE53935);
  static const Color successColorLight = Color(0xFF4CAF50);
  static const Color warningColorLight = Color(0xFFFFA726);

  // Gradients - Dark Mode
  static const List<Color> primaryGradient = [accentColor, secondaryAccent];
  static const List<Color> darkGradient = [primaryDark, Color(0xFF1A1B35)];
  static const List<Color> cardGradient = [Color(0xFF1E1F38), Color(0xFF15162D)];

  // Gradients - Light Mode
  static const List<Color> primaryGradientLight = [accentLightMode, secondaryAccentLightMode];
  static const List<Color> lightGradient = [Colors.white, Color(0xFFF0F3FA)];
  static const List<Color> cardGradientLight = [Colors.white, Color(0xFFF8F9FC)];

  // Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 350);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Animation curves
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve emphasizedCurve = Curves.easeOutBack;
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;

  // Theme transition duration
  static const Duration themeChangeDuration = Duration(milliseconds: 500);

  static ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: surfaceBackground,
      primaryColor: accentColor,
      colorScheme: const ColorScheme.dark(
        primary: accentColor,
        secondary: secondaryAccent,
        surface: cardBackground,
        background: surfaceBackground,
        error: errorColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: accentColor),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      cardTheme: const CardThemeData(
        color: cardBackground,
        elevation: 6,
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: textPrimary),
        titleSmall: TextStyle(color: textSecondary),
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textSecondary),
        bodySmall: TextStyle(color: textDisabled),
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        buttonColor: accentColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.black,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accentColor,
          side: const BorderSide(color: accentColor, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      // Add other theme configurations...
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: errorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: errorColor, width: 2),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 24,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return accentColor;
          }
          return Colors.grey[400];
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return accentColor.withOpacity(0.5);
          }
          return Colors.grey[700];
        }),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: const TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
      ),
      brightness: Brightness.dark,
    );
  }

  static ThemeData lightTheme() {
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: surfaceBackgroundLight,
      primaryColor: accentLightMode,
      colorScheme: const ColorScheme.light(
        primary: accentLightMode,
        secondary: secondaryAccentLightMode,
        surface: cardBackgroundLight,
        background: surfaceBackgroundLight,
        error: errorColorLight,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimaryLight,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: accentLightMode),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        color: cardBackgroundLight,
        elevation: 2,
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: textPrimaryLight),
        titleSmall: TextStyle(color: textSecondaryLight),
        bodyLarge: TextStyle(color: textPrimaryLight),
        bodyMedium: TextStyle(color: textSecondaryLight),
        bodySmall: TextStyle(color: textDisabledLight),
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        buttonColor: accentLightMode,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentLightMode,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: accentLightMode.withOpacity(0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accentLightMode,
          side: const BorderSide(color: accentLightMode, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: dividerColorLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: dividerColorLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentLightMode, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: errorColorLight, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: errorColorLight, width: 2),
        ),
        hintStyle: TextStyle(color: textDisabledLight),
        labelStyle: TextStyle(color: textSecondaryLight),
      ),
      dividerTheme: const DividerThemeData(
        color: dividerColorLight,
        thickness: 1,
        space: 24,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return accentLightMode;
          }
          return Colors.grey[300];
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return accentLightMode.withOpacity(0.5);
          }
          return Colors.grey[200];
        }),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cardBackgroundLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: const TextStyle(
          color: textPrimaryLight,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: cardBackgroundLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
      ),
      iconTheme: const IconThemeData(
        color: accentLightMode,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: accentLightMode,
      ),
      brightness: Brightness.light,
    );
  }

  // Helper methods for animations and transitions
  static Widget fadeTransition({required Widget child, required Animation<double> animation}) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  static Widget slideTransition({
    required Widget child,
    required Animation<double> animation,
    Offset beginOffset = const Offset(0.0, 0.1),
    Offset endOffset = Offset.zero,
  }) {
    final tween = Tween<Offset>(begin: beginOffset, end: endOffset);
    return SlideTransition(
      position: tween.animate(CurvedAnimation(
        parent: animation,
        curve: defaultCurve,
      )),
      child: child,
    );
  }

  // Helper method for conditional styling based on theme mode
  static T adaptive<T>({required T darkModeValue, required T lightModeValue, required bool isDarkMode}) {
    return isDarkMode ? darkModeValue : lightModeValue;
  }

  // Helper to create premium gradient backgrounds
  static BoxDecoration gradientBackground({required bool isDarkMode}) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: isDarkMode
            ? [primaryDark, Color(0xFF151B35)]
            : [primaryLightMode, Color(0xFFF0F3FA)],
      ),
    );
  }

  // Helper to create card decoration with appropriate theme mode styling
  static BoxDecoration cardDecoration({required bool isDarkMode}) {
    return BoxDecoration(
      color: isDarkMode ? cardBackground : cardBackgroundLight,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        if (isDarkMode)
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        else
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
      ],
    );
  }
}

// Custom clipper for wave pattern
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.85);

    final firstControlPoint = Offset(size.width * 0.25, size.height * 0.75);
    final firstEndPoint = Offset(size.width * 0.5, size.height * 0.85);
    path.quadraticBezierTo(
      firstControlPoint.dx, firstControlPoint.dy,
      firstEndPoint.dx, firstEndPoint.dy
    );

    final secondControlPoint = Offset(size.width * 0.75, size.height * 0.95);
    final secondEndPoint = Offset(size.width, size.height * 0.8);
    path.quadraticBezierTo(
      secondControlPoint.dx, secondControlPoint.dy,
      secondEndPoint.dx, secondEndPoint.dy
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// Animated wave painter
class WavePainter extends CustomPainter {
  final double animationValue;
  final Color color;
  final double opacity;

  WavePainter({
    required this.animationValue,
    required this.color,
    this.opacity = 0.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = size.height * 0.1;
    final waveWidth = size.width;
    final waveCount = 4;

    path.moveTo(0, size.height * 0.5);

    for (int i = 0; i <= waveCount; i++) {
      final dx = (waveWidth / waveCount) * i;
      final offsetDy = math.sin((animationValue * 2 * math.pi) + (i / waveCount) * 2 * math.pi) * waveHeight;
      path.lineTo(dx, size.height * 0.5 + offsetDy);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Extension for adding neomorphic effects
extension NeumorphicContainer on Container {
  static Container neomorphic({
    required Widget child,
    double borderRadius = 15.0,
    Color backgroundColor = AppTheme.cardBackground,
    EdgeInsets padding = const EdgeInsets.all(16.0),
    bool isPressed = false,
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isPressed
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(2, 2),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.05),
                  offset: const Offset(-2, -2),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(4, 4),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.07),
                  offset: const Offset(-4, -4),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
      ),
      child: child,
    );
  }
}
