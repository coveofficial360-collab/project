import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_config.dart';

enum SupabaseBootstrapStatus { ready, missingConfiguration, failed }

class SupabaseBootstrapResult {
  const SupabaseBootstrapResult({required this.status, required this.message});

  final SupabaseBootstrapStatus status;
  final String message;

  bool get isReady => status == SupabaseBootstrapStatus.ready;
}

class SupabaseBootstrap {
  static Future<SupabaseBootstrapResult> initialize() async {
    final missingConfigurationMessage =
        SupabaseConfig.missingConfigurationMessage;

    if (missingConfigurationMessage != null) {
      return SupabaseBootstrapResult(
        status: SupabaseBootstrapStatus.missingConfiguration,
        message: missingConfigurationMessage,
      );
    }

    try {
      await Supabase.initialize(
        url: SupabaseConfig.url,
        anonKey: SupabaseConfig.clientKey,
      );

      return const SupabaseBootstrapResult(
        status: SupabaseBootstrapStatus.ready,
        message: 'Supabase initialized successfully.',
      );
    } catch (error) {
      return SupabaseBootstrapResult(
        status: SupabaseBootstrapStatus.failed,
        message: error.toString(),
      );
    }
  }
}
