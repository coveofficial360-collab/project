import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/app_user.dart';
import '../session/app_session.dart';
import 'supabase_client.dart';

class AvenueRepository {
  AvenueRepository({SupabaseClient? client}) : _client = client ?? supabase;

  final SupabaseClient _client;

  Future<AppUser?> authenticate({
    required String email,
    required String password,
    required AppRole role,
  }) async {
    final response = await _client.rpc(
      'authenticate_app_user',
      params: {
        'p_email': email.trim().toLowerCase(),
        'p_password': password,
        'p_role': role.dbValue,
      },
    );

    if (response is! List || response.isEmpty) {
      return null;
    }

    final row = Map<String, dynamic>.from(response.first as Map);
    return AppUser.fromAuthRow(row);
  }

  Future<AppUser?> fetchCurrentUserProfile() async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return null;
    }

    final row = await _client
        .from('app_users')
        .select(
          'id, email, full_name, status, unit_number, tower, phone, avatar_url, job_title',
        )
        .eq('id', currentUser.id)
        .single();

    return AppUser.fromProfileRow(
      Map<String, dynamic>.from(row),
      currentUser.role,
    );
  }

  Future<List<Map<String, dynamic>>> fetchCurrentUserBills() async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return const [];
    }

    final rows = await _client
        .from('bills')
        .select()
        .eq('user_id', currentUser.id)
        .order('due_date', ascending: true);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchNotices({int limit = 10}) async {
    final rows = await _client
        .from('notices')
        .select()
        .order('posted_at', ascending: false)
        .limit(limit);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchCurrentUserNotifications() async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return const [];
    }

    final rows = await _client
        .from('notifications')
        .select()
        .eq('user_id', currentUser.id)
        .order('created_at', ascending: false);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchHouseholdMembers() async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return const [];
    }

    final rows = await _client
        .from('household_members')
        .select()
        .eq('user_id', currentUser.id)
        .order('created_at', ascending: true);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchVehicles() async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return const [];
    }

    final rows = await _client
        .from('vehicles')
        .select()
        .eq('user_id', currentUser.id)
        .order('created_at', ascending: true);

    return _castRows(rows);
  }

  Future<Map<String, dynamic>?> fetchAdminMetrics() async {
    final rows = await _client
        .from('admin_dashboard_metrics_v')
        .select()
        .limit(1);
    final records = rows as List<dynamic>;
    if (records.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(records.first as Map);
  }

  Future<List<Map<String, dynamic>>> fetchAdminTransactions() async {
    final rows = await _client
        .from('admin_transactions')
        .select()
        .order('created_at', ascending: false);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchResidentDirectory() async {
    final rows = await _client
        .from('resident_directory_v')
        .select()
        .order('full_name', ascending: true);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchGuardGateActivities() async {
    final rows = await _client
        .from('guard_gate_activity_v')
        .select()
        .order('expected_arrival', ascending: true);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchGuardDutyLogs() async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return const [];
    }

    final rows = await _client
        .from('guard_duty_logs')
        .select()
        .eq('guard_user_id', currentUser.id)
        .order('logged_at', ascending: false);

    return _castRows(rows);
  }

  List<Map<String, dynamic>> _castRows(dynamic rows) {
    if (rows is! List) {
      return const [];
    }

    return rows.map((row) => Map<String, dynamic>.from(row as Map)).toList();
  }
}
