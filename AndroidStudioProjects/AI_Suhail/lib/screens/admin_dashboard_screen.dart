import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../services/user_data_storage.dart';
import '../services/mock_database_service.dart';
import 'auth_welcome_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> with SingleTickerProviderStateMixin {
  String adminName = '';
  bool isLoading = false;
  List<Map<String, dynamic>> users = [];
  int selectedTabIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedTabIndex = _tabController.index;
      });
    });
    _loadAdminDetails();
    _loadAllUsers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAdminDetails() async {
    final user = await UserDataStorage.getCurrentUser();
    if (user != null && mounted) {
      setState(() {
        adminName = user['name'] ?? 'Admin';
      });
    }
  }

  Future<void> _loadAllUsers() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      final allUsers = await MockDatabaseService.getAllUsers();
      if (mounted) {
        setState(() {
          users = allUsers;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load users: $e'),
            backgroundColor: Colors.red.shade800,
          ),
        );
      }
    }
  }

  Future<void> _signOut() async {
    HapticFeedback.mediumImpact();
    await UserDataStorage.clearCurrentUser();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AuthWelcomeScreen()),
        (route) => false,
      );
    }
  }

  Future<void> _deleteUser(int userId) async {
    try {
      final success = await MockDatabaseService.deleteUser(userId);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('User deleted successfully'),
            backgroundColor: Colors.green.shade700,
          ),
        );
        _loadAllUsers();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cannot delete predefined users'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete user: $e'),
          backgroundColor: Colors.red.shade800,
        ),
      );
    }
  }

  Future<void> _updateUserRole(int userId, String newRole) async {
    try {
      final success = await MockDatabaseService.updateUser(userId, {'role': newRole});
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User role updated to $newRole'),
            backgroundColor: Colors.green.shade700,
          ),
        );
        _loadAllUsers();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update user role'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating user role: $e'),
          backgroundColor: Colors.red.shade800,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAllUsers,
            tooltip: 'Refresh Data',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Sign Out',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.accentColor,
          tabs: const [
            Tab(icon: Icon(Icons.people), text: 'Users'),
            Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
            Tab(icon: Icon(Icons.settings), text: 'Settings'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildUserManagementTab(),
            _buildAnalyticsTab(),
            _buildSettingsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserManagementTab() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.people_outline,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'No users found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadAllUsers,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
              ),
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Manage Users',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColorLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Total users: ${users.length}',
            style: TextStyle(
              color: AppTheme.textColorLight.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final userId = user['id'] as int;
                final userName = user['name'] as String;
                final userEmail = user['email'] as String;
                final userRole = user['role'] as String;

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  color: AppTheme.cardBackgroundDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: _getRoleColor(userRole),
                      child: Text(
                        userName[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      userName,
                      style: TextStyle(
                        color: AppTheme.textColorLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '$userEmail • ${userRole.toUpperCase()}',
                      style: TextStyle(
                        color: AppTheme.textColorLight.withOpacity(0.7),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(
                                  'Created: ${_formatDate(user['created_at'] as String)}',
                                  style: TextStyle(
                                    color: AppTheme.textColorLight.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Change Role:',
                              style: TextStyle(
                                color: AppTheme.textColorLight,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildRoleButton(
                                  'Customer',
                                  userRole == 'customer',
                                  () => _updateUserRole(userId, 'customer'),
                                ),
                                _buildRoleButton(
                                  'Publisher',
                                  userRole == 'publisher',
                                  () => _updateUserRole(userId, 'publisher'),
                                ),
                                _buildRoleButton(
                                  'Admin',
                                  userRole == 'admin',
                                  () => _updateUserRole(userId, 'admin'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: () => _deleteUser(userId),
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  label: const Text(
                                    'Delete User',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleButton(String role, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentColor : AppTheme.cardBackgroundDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.accentColor : Colors.grey,
            width: 1,
          ),
        ),
        child: Text(
          role,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textColorLight,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    // Sample data for analytics
    final usersByRole = {
      'admin': users.where((u) => u['role'] == 'admin').length,
      'publisher': users.where((u) => u['role'] == 'publisher').length,
      'customer': users.where((u) => u['role'] == 'customer').length,
    };

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User Analytics',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColorLight,
            ),
          ),
          const SizedBox(height: 24),
          _buildAnalyticsCard(
            'User Distribution by Role',
            Column(
              children: [
                _buildAnalyticsBar('Admins', usersByRole['admin']!, users.length, Colors.purple),
                const SizedBox(height: 16),
                _buildAnalyticsBar('Publishers', usersByRole['publisher']!, users.length, Colors.orange),
                const SizedBox(height: 16),
                _buildAnalyticsBar('Customers', usersByRole['customer']!, users.length, Colors.blue),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildAnalyticsCard(
            'System Usage',
            Column(
              children: [
                _buildAnalyticsBar('Active Users', users.length * 3 ~/ 4, users.length, Colors.green),
                const SizedBox(height: 16),
                _buildAnalyticsBar('Content Published', users.length ~/ 2, users.length, Colors.amber),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsBar(String label, int value, int total, Color color) {
    final percentage = total > 0 ? (value / total * 100) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: AppTheme.textColorLight,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$value (${percentage.toStringAsFixed(1)}%)',
              style: TextStyle(
                color: AppTheme.textColorLight,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey[800],
            color: color,
            minHeight: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsCard(String title, Widget content) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      color: AppTheme.cardBackgroundDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColorLight,
              ),
            ),
            const SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'System Settings',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColorLight,
            ),
          ),
          const SizedBox(height: 24),
          _buildSettingsCard(
            'Database',
            Column(
              children: [
                _buildSettingsSwitchTile(
                  'Enable Database Logging',
                  true,
                  (val) {/* Database logging toggle functionality */},
                ),
                _buildSettingsSwitchTile(
                  'Auto Backup (Daily)',
                  false,
                  (val) {/* Auto backup toggle functionality */},
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Database backup created'),
                          backgroundColor: Colors.green.shade700,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Create Backup Now'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsCard(
            'User Management',
            Column(
              children: [
                _buildSettingsSwitchTile(
                  'Allow New Registrations',
                  true,
                  (val) {/* Registration toggle functionality */},
                ),
                _buildSettingsSwitchTile(
                  'Email Verification Required',
                  true,
                  (val) {/* Email verification toggle functionality */},
                ),
                _buildSettingsSwitchTile(
                  'Auto-delete Inactive Users',
                  false,
                  (val) {/* Auto-delete toggle functionality */},
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsCard(
            'Content Settings',
            Column(
              children: [
                _buildSettingsSwitchTile(
                  'Content Moderation',
                  true,
                  (val) {/* Content moderation toggle functionality */},
                ),
                _buildSettingsSwitchTile(
                  'Allow User Comments',
                  true,
                  (val) {/* User comments toggle functionality */},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(String title, Widget content) {
    return Card(
      elevation: 4,
      color: AppTheme.cardBackgroundDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColorLight,
              ),
            ),
            const SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSwitchTile(String title, bool initialValue, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppTheme.textColorLight,
            ),
          ),
          Switch(
            value: initialValue,
            onChanged: onChanged,
            activeColor: AppTheme.accentColor,
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return Colors.purple;
      case 'publisher':
        return Colors.orange;
      case 'customer':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
