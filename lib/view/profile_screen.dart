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
  final user = FirebaseAuth.instance.currentUser;

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
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: widget.onThemeToggle,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 20),
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
          Text(
            user?.email ?? 'No email',
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: _handleLogout,
          ),
        ],
      ),
    );
  }
}
