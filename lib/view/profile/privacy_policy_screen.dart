import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              'Last updated: ${DateTime.now().year}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your privacy is important to us. This Privacy Policy explains how we collect, '
              'use, and protect your personal information.\n\n'
              '1. Information We Collect\n'
              'We collect information that you provide directly to us, including your name, '
              'email address, and vehicle information.\n\n'
              '2. How We Use Your Information\n'
              'We use the information we collect to provide and improve our services, '
              'communicate with you, and ensure a better user experience.\n\n'
              '3. Data Security\n'
              'We implement appropriate technical and organizational measures to protect '
              'your personal information against unauthorized access, alteration, disclosure, '
              'or destruction.\n\n'
              '4. Your Rights\n'
              'You have the right to access, correct, or delete your personal information. '
              'You can manage your information through the app settings.',
            ),
          ],
        ),
      ),
    );
  }
}
