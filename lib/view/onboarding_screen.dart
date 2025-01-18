import 'package:flutter/material.dart';
import 'package:drive_secure/common/services/preferences_service.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});
  
  Future<void> _onGetStarted(BuildContext context) async {
    try {
      final prefs = await PreferencesService.getInstance();
      await prefs.setHasSeenOnboarding();
      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Image.asset(
                'assets/images/vehicle.png',
                height: 300,
              ),
              const SizedBox(height: 48),
              Text(
                'Monitor Your Vehicles',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'Track and manage your vehicle fleet with ease',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _onGetStarted(context),
                  child: const Text('Get Started'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
