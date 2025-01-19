import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms of Service',
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
              'Welcome to Drive Secure. By using our app, you agree to these terms. '
              'Please read them carefully.\n\n'
              '1. Acceptance of Terms\n'
              'By accessing and using Drive Secure, you accept and agree to be bound by the terms '
              'and provision of this agreement.\n\n'
              '2. Use License\n'
              'Permission is granted to temporarily download one copy of Drive Secure for personal, '
              'non-commercial transitory viewing only.\n\n'
              '3. Disclaimer\n'
              'The materials on Drive Secure are provided on an \'as is\' basis. Drive Secure '
              'makes no warranties, expressed or implied, and hereby disclaims and negates all '
              'other warranties including, without limitation, implied warranties or conditions '
              'of merchantability, fitness for a particular purpose, or non-infringement of '
              'intellectual property or other violation of rights.',
            ),
          ],
        ),
      ),
    );
  }
}
