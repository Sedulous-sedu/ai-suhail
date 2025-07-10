import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../services/mock_database_service.dart';
import '../services/user_profile_service.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'auth_welcome_screen.dart';
import '../widgets/grid_painter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final double _initialHologramScale = 0.1;
  final double _targetHologramScale = 1.0;
  double _currentHologramScale = 0.1;
  final userId = 1;

  Map<String, dynamic>? _userProfile;
  List<Map<String, dynamic>> _toolUsageHistory = [];
  bool _isLoading = true;
  bool _showStats = false;
  int _selectedTabIndex = 0;

  final List<String> _tabTitles = [
    'OVERVIEW',
    'ACTIVITY',
    'SETTINGS',
    'SUBSCRIPTION'
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..addListener(() {
      setState(() {
        _currentHologramScale = _initialHologramScale +
            (_targetHologramScale - _initialHologramScale) *
            _controller.drive(CurveTween(curve: Curves.easeOutCubic)).value;
      });
    });

    _loadUserData();
    _animateEntrance();
  }

  Future<void> _loadUserData() async {
    try {
      final profile = await MockDatabaseService.getUserProfile(userId);
      final history = await MockDatabaseService.getToolUsageHistory(userId);

      setState(() {
        _userProfile = profile;
        _toolUsageHistory = history;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _animateEntrance() async {
    await Future.delayed(const Duration(milliseconds: 300));
    HapticFeedback.mediumImpact();
    _controller.forward();
    await Future.delayed(const Duration(milliseconds: 2800));
    setState(() {
      _showStats = true;
    });
    HapticFeedback.lightImpact();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        title: ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: [Color(0xFF00E5FF), Color(0xFF00AAFF)],
            ).createShader(bounds);
          },
          child: const Text(
            'PROFILE',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? _buildLoadingView()
          : _userProfile == null
              ? _buildErrorView()
              : _buildProfileView(),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00E5FF)),
      ),
    );
  }

  Widget _buildErrorView() {
    return const Center(
      child: Text(
        'Error loading profile',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildProfileView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 100),
          _buildUserHologram(),
          _buildUserInfo(),
          _buildTabSelector(),
          _buildTabContent(),
        ],
      ),
    );
  }

  Widget _buildUserHologram() {
    return Center(
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF00E5FF), width: 2),
        ),
        child: const Icon(
          Icons.person,
          color: Color(0xFF00E5FF),
          size: 80,
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            _userProfile?['name'] ?? 'User Name',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _userProfile?['email'] ?? 'user@example.com',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _tabTitles.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedTabIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedTabIndex = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF00E5FF) : Colors.transparent,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: const Color(0xFF00E5FF)),
              ),
              child: Center(
                child: Text(
                  _tabTitles[index],
                  style: TextStyle(
                    color: isSelected ? Colors.black : const Color(0xFF00E5FF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabContent() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Text(
        'Tab content will be implemented here',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
