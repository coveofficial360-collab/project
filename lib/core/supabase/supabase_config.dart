class SupabaseConfig {
  static const String url = String.fromEnvironment('SUPABASE_URL');
  static const String publishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );
  static const String anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static String get clientKey =>
      publishableKey.isNotEmpty ? publishableKey : anonKey;

  static bool get isConfigured => url.isNotEmpty && clientKey.isNotEmpty;

  static String? get missingConfigurationMessage {
    if (url.isEmpty && clientKey.isEmpty) {
      return 'Missing SUPABASE_URL and SUPABASE_PUBLISHABLE_KEY.';
    }

    if (url.isEmpty) {
      return 'Missing SUPABASE_URL.';
    }

    if (clientKey.isEmpty) {
      return 'Missing SUPABASE_PUBLISHABLE_KEY.';
    }

    return null;
  }
}
