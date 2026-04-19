import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_client.dart';

class SupabaseAuthService {
  SupabaseAuthService({SupabaseClient? client}) : _client = client ?? supabase;

  final SupabaseClient _client;

  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() {
    return _client.auth.signOut();
  }
}
