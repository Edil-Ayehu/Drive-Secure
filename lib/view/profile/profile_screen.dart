import 'package:drive_secure/view/profile/battery_alert_screen.dart';
import 'package:drive_secure/view/profile/change_password_screen.dart';
import 'package:drive_secure/view/profile/edit_profile_screen.dart';
import 'package:drive_secure/view/profile/fuel_unit_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:drive_secure/common/services/auth_service.dart';
import 'package:drive_secure/common/utils/dialog_utils.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;

  const ProfileScreen({
    super.key,
    required this.onThemeToggle,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  User? user;

  @override
  void initState() {
    super.initState();
    _refreshUser();
  }

  void _refreshUser() {
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
  }

  Future<void> _handleLogout() async {
    final confirmed = await DialogUtils.showLogoutConfirmationDialog(context);

    if (confirmed ?? false) {
      try {
        await _authService.signOut();
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error logging out: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 20),
          // Profile Image Section
          CircleAvatar(
            radius: 50,
            backgroundColor: theme.primaryColor.withOpacity(0.1),
            child: Icon(
              Icons.person,
              size: 50,
              color: theme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          // Display name if available
          if (user?.displayName?.isNotEmpty ?? false)
            Text(
              user!.displayName!,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 8),
          // Email
          Text(
            user?.email ?? 'No email',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Account Settings Section
          _buildSectionHeader(theme, 'Account Settings'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Edit Profile'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );

                    if (result == true && mounted) {
                      _refreshUser();
                    }
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: const Text('Change Password'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangePasswordScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // App Settings Section
          _buildSectionHeader(theme, 'App Settings'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: const Text('Notifications'),
                  trailing: Switch(
                    value: true, // TODO: Implement notifications state
                    onChanged: (value) {
                      // TODO: Implement notifications toggle
                    },
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: Icon(
                    isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  ),
                  title: const Text('Theme'),
                  trailing: Switch(
                    value: isDarkMode,
                    onChanged: (_) => widget.onThemeToggle(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Vehicle Preferences Section
          _buildSectionHeader(theme, 'Vehicle Preferences'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.speed_outlined),
                  title: const Text('Default Fuel Unit'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FuelUnitScreen(),
                      ),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.battery_charging_full_outlined),
                  title: const Text('Battery Alert Threshold'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BatteryAlertScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // About Section
          _buildSectionHeader(theme, 'About'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('App Version'),
                  trailing:
                      const Text('1.0.0'), // TODO: Implement version tracking
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Terms of Service'),
                  onTap: () {
                    // TODO: Implement terms of service
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Privacy Policy'),
                  onTap: () {
                    // TODO: Implement privacy policy
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Logout Section
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
              onTap: _handleLogout,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
