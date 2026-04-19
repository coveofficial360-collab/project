import 'package:flutter/material.dart';

import '../../../app/app_page.dart';
import '../../../core/supabase/supabase_bootstrap.dart';
import '../../../theme/avenue_theme.dart';

class SupabaseSetupScreen extends StatelessWidget {
  const SupabaseSetupScreen({required this.bootstrapResult, super.key});

  static const String routeName = '/supabase-setup';

  final SupabaseBootstrapResult bootstrapResult;

  @override
  Widget build(BuildContext context) {
    final isFailure = bootstrapResult.status == SupabaseBootstrapStatus.failed;

    return Scaffold(
      backgroundColor: AvenueColors.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      gradient: AvenueColors.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x33005BBF),
                          blurRadius: 24,
                          offset: Offset(0, 12),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.cloud_done_rounded,
                      size: 34,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Supabase Setup',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isFailure
                        ? 'The app found Supabase credentials, but initialization failed.'
                        : 'The app is ready for Supabase, but project credentials have not been provided yet.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AvenueColors.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _StatusCard(
                    title: isFailure
                        ? 'Initialization error'
                        : 'Missing configuration',
                    body: bootstrapResult.message,
                    accentColor: isFailure
                        ? const Color(0xFFD6453A)
                        : AvenueColors.primary,
                    icon: isFailure
                        ? Icons.error_outline_rounded
                        : Icons.key_rounded,
                  ),
                  const SizedBox(height: 20),
                  _InstructionCard(
                    title: '1. Create a local config file',
                    body:
                        'Copy env.example.json to env.json and paste your Supabase URL and publishable key.',
                  ),
                  const SizedBox(height: 12),
                  _InstructionCard(
                    title: '2. Run the app with dart defines',
                    body:
                        'Use flutter run --dart-define-from-file=env.json so the credentials are loaded securely at build time.',
                  ),
                  const SizedBox(height: 12),
                  _InstructionCard(
                    title: '3. Continue with real auth and queries',
                    body:
                        'Once the keys are present, the app boots through Supabase.initialize and is ready for auth, reads, writes, and realtime flows.',
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AvenueColors.outlineVariant.withValues(
                          alpha: 0.28,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Command',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 10),
                        SelectableText(
                          'flutter run --dart-define-from-file=env.json',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pushReplacementNamed(AppPage.login.routeName);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AvenueColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(56),
                      shape: const StadiumBorder(),
                      textStyle: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    child: const Text('Continue With UI Preview'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.title,
    required this.body,
    required this.accentColor,
    required this.icon,
  });

  final String title;
  final String body;
  final Color accentColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withValues(alpha: 0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accentColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AvenueColors.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InstructionCard extends StatelessWidget {
  const _InstructionCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AvenueColors.onSurfaceVariant,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
